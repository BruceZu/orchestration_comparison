#--------------------------------------------------------------
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#--------------------------------------------------------------


class ghost () {

  $target = '/mnt'

  if $stratos_app_path {
    $nodejs_home = $stratos_app_path
  } 
  else {
    $nodejs_home = "${target}/nodejs"
  }  

  exec {
    'Create nodejs home':
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      command => "mkdir -p ${nodejs_home}";

    'Wait':
      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd     => "${nodejs_home}",
      command => "echo 'test for package.json' && test -f package.json",
      tries => 100,
      try_sleep => 2,
      require => Exec['Create nodejs home'];

#    'Install':
#      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#      cwd     => "${nodejs_home}",
#      command => "npm set strict-ssl false && echo 'install grunt-cli' && npm install -g grunt-cli && echo 'execute npm install' && npm install",
#      require => Exec['Wait'];

      'Install':
        path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        cwd     => "${nodejs_home}",
        command => "npm set strict-ssl false && npm install --production >> /var/log/npminstall.log 2>&1",
        tries => 5,
        try_sleep => 1,
        require => Exec['Wait'];
  } 

#  exec {
#    'Build':
#      path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
#      cwd     => "${nodejs_home}",
#      command => "grunt init && grunt prod",
#      require => Exec['Install'];
#  } 

  file {
   '/mnt/nodejs/config.js':
      owner   => 'root',
      group   => 'root',
      mode    => '0775',
      content => template('/etc/puppet/modules/ghost/templates/ghost/config.js.erb'),
      require => Exec['Install'];
  }

 exec{
    'Start application':
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => "${nodejs_home}",
      command   => 'npm start --production > /var/log/nodejsapp.log 2>&1 &',
      tries => 5,
      try_sleep => 2,
      require   => [
                        File['/mnt/nodejs/config.js']
                        #Exec['Install'],
			#Exec['Build']
                ];
}
  

  Class['stratos_base'] -> Class['nodejs'] -> Class['ghost']
}
