###############################################################################
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
###############################################################################

import os
import subprocess
import tempfile
from contextlib import contextmanager

from jinja2 import Template

from cloudify_rest_client import exceptions as rest_exceptions
from cloudify import ctx
from cloudify.state import ctx_parameters as inputs
from cloudify import exceptions
from cloudify import utils


CONFIG_PATH = '/opt/ghost/config.js'
TEMPLATE_RESOURCE_NAME = 'resources/ghost/ghost.default.template'


def configure(subject=None):
    

    ctx.logger.info('Configuring ghost.')
    
    _run('sudo apt-get -y install unzip',error_message='Failed installing unzip')
    _run('sudo curl -L https://ghost.org/zip/ghost-latest.zip -o /opt/ghost.zip',error_message='Failed downloading ghost')
    _run('sudo unzip -uo /opt/ghost.zip -d /opt/ghost',error_message='Failed unzipping ghost')  
    
    writeConfig(subject)

def writeConfig(subject=None):
    
    subject = subject or ctx
    postgre_ip_address = subject.instance.runtime_properties["postgre_ip_address"]
    
    template = Template(ctx.get_resource(TEMPLATE_RESOURCE_NAME))

    ctx.logger.debug('Building a dict object that will contain variables '
                     'to write to the Jinja2 template.')

    config = subject.node.properties.copy()
    config.update(dict(
        postgre_ip=postgre_ip_address))

    ctx.logger.debug('Rendering the Jinja2 template to {0}.'.format(CONFIG_PATH))
    ctx.logger.debug('The config dict: {0}.'.format(config))

    with tempfile.NamedTemporaryFile(delete=False) as temp_config:
        temp_config.write(template.render(config))

    #_run('sudo /usr/sbin/haproxy -f {0} -c'.format(temp_config.name),
    #     error_message='Failed to Configure')

    _run('sudo mv {0} {1}'.format(temp_config.name, CONFIG_PATH),
         error_message='Failed to write to {0}.'.format(CONFIG_PATH))

def stop():
    _run('sudo killall node',error_message='Failed killing nodejs')

def _run(command, error_message):
    runner = utils.LocalCommandRunner(logger=ctx.logger)
    try:
        runner.run(command)
    except exceptions.CommandExecutionException as e:
        raise exceptions.NonRecoverableError('{0}: {1}'.format(error_message, e))


def _main():
    invocation = inputs['invocation']
    function = invocation['function']
    args = invocation.get('args', [])
    kwargs = invocation.get('kwargs', {})
    globals()[function](*args, **kwargs)


if __name__ == '__main__':
    _main()