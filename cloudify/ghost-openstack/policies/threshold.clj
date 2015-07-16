(where (service #"{{service}}")
  (where (>= metric {{threshold}})
    process-policy-triggers))