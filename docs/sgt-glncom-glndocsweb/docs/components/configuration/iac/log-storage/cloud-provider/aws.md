# AWS Cloudwatch

The resource should be defined as a map of maps with one key per resource. See the following [AWS Input example](#AWSInputExample).

## Prerequisites & Dependencies

The following requirements must be met before the deployment can take place:

* AWS KMS key to encrypt Log Groups and/or Event Bus. (Optional)
* AWS IAM Role for events. (Optional)
* AWS ECS Cluster to use as target for the resource 'aws_cloudwatch_event_target'. (Optional)
* AWS VPC, subnet and security groups to use as part of the configuration of the ECS target for the resource 'aws_cloudwatch_event_target'. (Optional)
* AWS ECS task definition to use as part of the configuration of the ECS target for the resource 'aws_cloudwatch_event_target'. (Optional)
* AWS Kinesis Stream to use as target for the resource 'aws_cloudwatch_event_target'. (Optional)
* AWS SQS queue to use as target for the resource 'aws_cloudwatch_event_target'. (Optional)
* AWS Batch job to use as target for the resource 'aws_cloudwatch_event_target'. (Optional)

<a name = "AWSInputExample"></a>

## Input example

```hcl
aws_logstorage = {
  "acw_default" = {
    # -------------
    # Tags
    # -------------
    tags = {
      product     = "Gluon AWS CloudWatch"
      environment = "dev"
      project     = "Gluon"
    }

    # -------------
    # Naming
    # -------------
    name = "glnd1airacwtest001"

    # -------------
    # Security
    # -------------
    kms_key_arn = "arn:aws:kms:eu-west-1:<aws_account_id>:key/466b6f3c-621a-4222-a01f-17f4b05826b1"

    # ----------------------
    # CloudWatch Dashboard
    # ----------------------
    dashboards = {
      "dashboard1" = {
        sequence       = "001"
        dashboard_body = <<EOF
        {
          "widgets": [
            {
              "type": "metric",
              "x": 0,
              "y": 0,
              "width": 12,
              "height": 6,
              "properties": {
                "metrics": [
                  [
                    "AWS/EC2",
                    "CPUUtilization",
                    "InstanceId",
                    "i-0ae8b7af4ebd01bd1"
                  ]
                ],
                "period": 300,
                "stat": "Average",
                "region": "eu-west-1",
                "title": "EC2 Instance CPU"
              }
            },
            {
              "type": "text",
              "x": 0,
              "y": 7,
              "width": 3,
              "height": 3,
              "properties": {
                "markdown": "Dashboard 1 Test"
              }
            },
            {
            "type": "log",
            "x": 12,
            "y": 24,
            "width": 12,
            "height": 6,
            "properties": {
            "region": "eu-west-1",
            "title": "Errors (Application Log)",
            "query": "SOURCE 'glnd3airacwtest01gene001-log_group' | filter @message like \"[ERROR]\"\n | fields @timestamp, @message | sort @timestamp desc | limit 20",
            "view": "table"
            }
          }

          ]

        }
        EOF
      }
      "dashboard2" = {
        name           = "acwdashcustomname"
        dashboard_body = <<EOF
        {
          "widgets": [
            {
              "type": "metric",
              "x": 0,
              "y": 0,
              "width": 12,
              "height": 6,
              "properties": {
                "metrics": [
                  [
                    "AWS/EC2",
                    "CPUUtilization",
                    "InstanceId",
                    "i-012345"
                  ]
                ],
                "period": 300,
                "stat": "Average",
                "region": "eu-west-2",
                "title": "EC2 Instance CPU"
              }
            },
            {
              "type": "text",
              "x": 0,
              "y": 7,
              "width": 3,
              "height": 3,
              "properties": {
                "markdown": "Dashboard 2 Test"
              }
            }
          ]
        }
        EOF
      }
    }

    # --------------------------
    # CloudWatch Metric Alarms
    # --------------------------
    metric_alarms = {
      "metric_1" = {
        sequence                  = "001"
        comparison_operator       = "GreaterThanOrEqualToThreshold"
        metric_name               = "CPUUtilization"
        namespace                 = "TEST/GLN"
        period                    = 120
        evaluation_periods        = 2
        statistic                 = "Average"
        actions_enabled           = true
        alarm_description         = "Test"
        datapoints_to_alarm       = 1
        insufficient_data_actions = []
        unit                      = "Count"
        treat_missing_data        = "missing"
      }
      "metric_2" = {
        name                      = "acwmetricustomname"
        comparison_operator       = "GreaterThanUpperThreshold"
        evaluation_periods        = 1
        actions_enabled           = true
        alarm_description         = "Test"
        datapoints_to_alarm       = 1
        insufficient_data_actions = []
        treat_missing_data        = "missing"
        threshold_metric_id       = "a1"
        metric_query = {
          "metric_query_1" = {
            id          = "a1"
            account_id  = "<aws_account_id>"
            expression  = "ANOMALY_DETECTION_BAND(m1)"
            label       = "CPUUtilization (Expected)"
            return_data = true
          }
          "metric_query_2" = {
            id          = "m1"
            account_id  = "<aws_account_id>"
            label       = "CPUUtilization (Expected)"
            return_data = true
            metric = {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              period      = "120"
              stat        = "Average"
              unit        = "Count"

              dimensions = {
                InstanceId = "i-abc123"
              }
            }
          }
        }
      }
    }

    # ----------------------
    # CloudWatch log group
    # ----------------------
    create_log_group       = true
    retention_in_days      = 1
    log_group_skip_destroy = false
    log_group_class        = "STANDARD"
    log_tags = {
      test = "Log Group Test"
    }

    # ------------------------
    # CloudWatch log streams
    # ------------------------
    log_streams = {
      "log_stream1" = {
        sequence = "001"
      }
      "log_stream2" = {
        name = "aclogstreamcustomname"
      }
    }

    # --------------------------------
    # CloudWatch log resource policy
    # --------------------------------
    log_resource_policy = {
      "log_policy1" = {
        sequence        = "001"
        policy_document = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": ["events.amazonaws.com", "delivery.logs.amazonaws.com", "logs.amazonaws.com"]
              },
              "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
              ],
              "Resource": "*"
            }
          ]
        }
        EOF
      }
      "log_policy2" = {
        name            = "acwlogpolcustomname"
        policy_document = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": ["events.amazonaws.com", "delivery.logs.amazonaws.com", "logs.amazonaws.com"]
              },
              "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
              ],
              "Resource": "*"
            }
          ]
        }
        EOF
      }
      "log_policy3" = {
        sequence        = "003"
        policy_document = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": ["events.amazonaws.com", "delivery.logs.amazonaws.com", "logs.amazonaws.com"]
              },
              "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
              ],
              "Resource": "*"
            }
          ]
        }
        EOF
      }
    }

    # ------------------------------------
    # Cloudwatch log subscription filter
    # ------------------------------------
    log_subscription_filter = {
      "sub_filter1" = {
        sequence        = "001"
        filter_pattern  = "logtype test"
        distribution    = "Random"
        role_arn        = "arn:aws:iam::<aws_account_id>:role/glnd1airiamroletest000"
        destination_arn = "arn:aws:kinesis:eu-west-1:<aws_account_id>:stream/glnd1airkintest000"
      }
      "sub_filter2" = {
        name            = "acwlogsubfiltercustomname"
        filter_pattern  = "logtype test2"
        distribution    = "Random"
        role_arn        = "arn:aws:iam::<aws_account_id>:role/glnd1airiamroletest000"
        destination_arn = "arn:aws:kinesis:eu-west-1:<aws_account_id>:stream/glnd1airkintest000"
      }
    }

    # ----------------------
    # Cloudwatch event bus
    # ----------------------
    create_event_bus = true

    event_bus_tags = {
      test = "ACW Event Bus test tag"
    }

    # -----------------------------
    # Cloudwatch event bus policy
    # -----------------------------
    event_bus_policies = {
      "bus_policy_1" = {
        policy = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "5",
              "Effect": "Allow",
              "Principal": "*",
              "Action": [
                "events:DescribeRule",
                "events:ListRules",
                "events:ListTargetsByRule",
                "events:ListTagsForResource",
                "events:PutEvents"
              ],
              "Resource": "*"
            }
          ]
        }
        EOF
      }
      "bus_policy_2" = {
        default_event_bus = true
        policy            = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Sid": "10",
              "Effect": "Allow",
              "Principal": "*",
              "Action": [
                "events:DescribeRule",
                "events:ListRules",
                "events:PutEvents"
              ],
              "Resource": "*"
            }
          ]
        }
        EOF
      }
    }

    # -----------------------
    # Cloudwatch event rule
    # -----------------------
    event_rules = {
      "rule_1" = {
        sequence    = "001"
        description = "ACW - Test"
        state       = "ENABLED"
        tags = {
          test = "ACW Event Rules test tag"
        }
        event_pattern = <<EOF
        {
          "source": ["ec2.amazonaws.com"],
          "detail-type": ["AWS API Call via CloudTrail"],
          "detail": {
            "eventSource": ["ec2.amazonaws.com"],
            "eventName": ["CreateVpc"]
          }
        }
        EOF
      }
    }

    # -------------------------
    # Cloudwatch event target
    # -------------------------
    event_targets = {
      "sqs" = {
        rule_key  = "rule_1"
        target_id = "Test"
        arn       = "arn:aws:sqs:eu-west-1:<aws_account_id>:glnd1airsqstestgene000.fifo"
        sqs_target = {
          message_group_id = "perMessagGroupId"
        }
      }
    }
  }
}
```

## Required parameters for deployment

| Name | Description | Type |
|------|-------------|------|
| name | The name of the CloudWatch resources. If the custom name of the resource is not provided, the name would be <var.name>-<resource\_type>. | <pre>any</pre> |

## Optional parameters for deployment

| Name | Description | Type | Default |
|------|-------------|------|---------|
| create_event_bus | If true, a CloudWatch Event Bus will be created. | <pre>bool</pre> | false |
| create_kms_key | If true, a new KMS key will be created. :warning: The attribute 'kms\_key\_arn' cannot be provided if this variable is set to 'true', they cannot be set together. | <pre>bool</pre> | false |
| create_log_group | If true, a log group resource will be created. | <pre>bool</pre> | false |
| [dashboards](#input_dashboards) | Block containing the configuration needed to deploy CloudWatch Dashboards. | <pre>any</pre> | {} |
| deletion_window_in_days | Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days. Should only be set when 'create\_kms\_key' and 'create\_log\_group' or 'create\_event\_bus' are set to 'true'. | <pre>number</pre> | 30 |
| event_bus_name | The custom name of the new event bus. The names of custom event buses can't contain the / character. To create a partner event bus, ensure the name matches the event\_source\_name. If not provided, the name would be '<var.name>-event\_bus'. | <pre>string</pre> | null |
| [event_bus_policies](#input_event_bus_policies) | Block containing the configuration needed to deploy a CloudWatch Event Bus Policy. | <pre>any</pre> | {} |
| event_bus_tags | A map of tags to add to all the event bus resources. Final event bus tags will be a merged structure between these tags and 'var.tags'. | <pre>any</pre> | {} |
| event_rule_tags | A map of tags to add to all the CloudWatch Event Rule resources. | <pre>any</pre> | {} |
| [event_rules](#input_event_rules) | Block containing the configuration needed to deploy a CloudWatch Event Rule. | <pre>any</pre> | {} |
| event_source_name | The partner event source that the new event bus will be matched with. Must match 'name'. | <pre>string</pre> | null |
| [event_targets](#input_event_targets) | Block containing the configuration needed to deploy a CloudWatch Event Target. | <pre>any</pre> | {} |
| kms_key_arn | The ARN of the KMS Key to use when encrypting log data or event bus. :warning: The attribute 'kms\_key\_arn' cannot be provided if this variable is set to 'true', they cannot be set together. | <pre>string</pre> | null |
| kms_key_description | The description of the key as viewed in AWS console. Should only be set when 'create\_kms\_key' and 'create\_log\_group' or 'create\_event\_bus' are set to 'true'. | <pre>string</pre> | "Key created to provide envelope encryption of Amazon CloudWatch." |
| kms_name | The name of the KMS Key that will be created to encrypt the Cloudwatch Log Group. This parameter is required when 'create\_kms\_key' and 'create\_log\_group' or 'create\_event\_bus' are set to 'true'. | <pre>string</pre> | null |
| kms_statements_policy | User Policy for CloudWatch KMS key. | <pre>any</pre> | {} |
| kms_tags | KMS key unique tags. This map will be merged with the common tags defined in the variable 'var.tags'. Should only be set when 'create\_kms\_key' and 'create\_log\_group' or 'create\_event\_bus' are set to 'true'. | <pre>any</pre> | {} |
| log_group_class | Specified the log class of the log group. Possible values are: 'STANDARD' or 'INFREQUENT\_ACCESS'. Change this forces a new resource to be created. | <pre>string</pre> | "STANDARD" |
| log_group_name | The name of the log group. If omitted, Terraform will assign a random, unique name. If changed, forces a new resource. If not provided, the name would be '<var.name>-log\_group'. | <pre>string</pre> | null |
| log_group_skip_destroy | Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state. | <pre>bool</pre> | false |
| [log_resource_policy](#input_log_resource_policy) | Block containing the configuration needed to deploy a CloudWatch Log Resource Policy. | <pre>any</pre> | {} |
| [log_streams](#input_log_streams) | Block containing the configuration needed to associate a CloudWatch Log Stream with a CloudWatch Log Group. | <pre>any</pre> | {} |
| [log_subscription_filter](#input_log_subscription_filter) | Block containing the configuration needed to deploy a CloudWatch Log Subscription Filter. | <pre>any</pre> | {} |
| log_tags | A map of tags to add to all the log group resources. Final log group tags will be a merged structure between these tags and 'var.tags'. | <pre>any</pre> | {} |
| [metric_alarms](#input_metric_alarms) | Block containing the configuration needed to deploy CloudWatch Metric Alarms. | <pre>any</pre> | {} |
| metric_tags | A map of tags to add to all the metric alarm resources. | <pre>any</pre> | {} |
| retention_in_days | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653. If you select 0, the events in the log group are always retained and never expire. | <pre>number</pre> | 30 |
| tags | A map of tags to add to all resources. | <pre>any</pre> | {} |

## Block Parameters

### <a name="input_dashboards"></a> [dashboards](#input\_dashboards)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| dashboard_body | (Required) The detailed information about the dashboard, including what widgets are included and their location on the dashboard. You can read more about the body structure in the [documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html). | <pre>string</pre> |
| name | (Optional) Define a custom name for the CloudWatch Dashboard. If not provided, the name would be '<var.name>-dashboard<code>sequence</code>'. | <pre>string</pre> |
| sequence | (Required if 'name' is not set) Number of the resource to be created. | <pre>string</pre> |

### <a name="input_event_bus_policies"></a> [event\_bus\_policies](#input\_event\_bus\_policies)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| default_event_bus | (Optional) Whether to associate the policy to the default bus (true) or the event bus deployed. False by default. | <pre>bool</pre> |
| policy | (Required) The text of the policy. For more information about building AWS IAM policy documents with Terraform, see the [AWS IAM Policy Document Guide](https://developer.hashicorp.com/terraform/tutorials/aws/aws-iam-policy). | <pre>string</pre> |

### <a name="input_event_rules"></a> [event\_rules](#input\_event\_rules)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| default_event_bus | (Optional) Whether to associate the rule to the default Event Bus (true) or the Event Bus deployed. False by default. | <pre>bool</pre> |
| description | (Optional) The description of the rule. | <pre>string</pre> |
| event_pattern | (Optional) The event pattern described a JSON object. :warning: At least one of schedule\_expression or event\_pattern is required. See full documentation of [Events and Event Patterns in EventBridge](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-events.html) for details. Note: The event pattern size is 2048 by default but it is adjustable up to 4096 characters by submitting a service quota increase request. See [Amazon EventBridge quotas](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-quota.html) for details. | <pre>map(string)</pre> |
| name | (Optional) The name of the rule. If not provided, the name would be '<var.name>-event\_rule<code>sequence</code>'. | <pre>string</pre> |
| role_arn | (Optional) The Amazon Resource Name (ARN) associated with the role that is used for target invocation. | <pre>string</pre> |
| schedule_expression | (Optional) The scheduling expression. For example, cron(0 20 ** ? *) or rate(5 minutes). :warning: At least one of schedule\_expression or event\_pattern is required. Can only be used on the default event bus. For more information, refer to the AWS documentation [Schedule Expressions for Rules](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-create-rule-schedule.html). | <pre>string</pre> |
| sequence | (Required if 'name' is not set) Number of the resource to be created. | <pre>string</pre> |
| state | (Optional) State of the rule. Valid values are 'DISABLED', 'ENABLED', and 'ENABLED\_WITH\_ALL\_CLOUDTRAIL\_MANAGEMENT\_EVENTS'. When state is 'ENABLED', the rule is enabled for all events except those delivered by CloudTrail. To also enable the rule for events delivered by CloudTrail, set 'state' to 'ENABLED\_WITH\_ALL\_CLOUDTRAIL\_MANAGEMENT\_EVENTS'. Defaults to 'ENABLED'. :warning: The rule state 'ENABLED\_WITH\_ALL\_CLOUDTRAIL\_MANAGEMENT\_EVENTS' cannot be used in conjunction with the 'schedule\_expression' argument. | <pre>string</pre> |
| tags | (Optional) A map of tags to assign to the resource. This map will be merged with the common tags defined in the variable 'var.tags' and 'var.event\_rule\_tags'. | <pre>map(string)</pre> |

### <a name="input_event_targets"></a> [event\_targets](#input\_event\_targets)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| arn | (Required) The Amazon Resource Name (ARN) of the target. | <pre>string</pre> |
| batch_target | (Optional) Parameters used when you are using the rule to invoke an Amazon Batch Job. A maximum of 1 are allowed. | <pre>object</pre> |
| batch_target<br/>.array_size | (Optional) The size of the array, if this is an array batch job. Valid values are integers between 2 and 10,000. | <pre>number</pre> |
| batch_target<br/>.job_attempts | (Optional) The number of times to attempt to retry, if the job fails. Valid values are 1 to 10. | <pre>number</pre> |
| batch_target<br/>.job_definition | (Required) The ARN or name of the job definition to use if the event target is an AWS Batch job. This job definition must already exist. | <pre>string</pre> |
| batch_target<br/>.job_name | (Required) The name to use for this execution of the job, if the target is an AWS Batch job. | <pre>string</pre> |
| dead_letter_config | (Optional) Parameters used when you are providing a dead letter config. A maximum of 1 are allowed. | <pre>object</pre> |
| dead_letter_config<br/>.arn | (Optional) - ARN of the SQS queue specified as the target for the dead-letter queue. | <pre>string</pre> |
| ecs_target | (Optional) Parameters used when you are using the rule to invoke Amazon ECS Task. A maximum of 1 are allowed. | <pre>object</pre> |
| ecs_target-group | (Optional) Specifies an ECS task group for the task. The maximum length is 255 characters. | <pre>string</pre> |
| ecs_target<br/>.capacity_provider_strategy | (Optional) The capacity provider strategy to use for the task. If a 'capacity\_provider\_strategy' is specified, the 'launch\_type' parameter must be omitted. If no 'capacity\_provider\_strategy' or 'launch\_type' is specified, the default capacity provider strategy for the cluster is used. Can be one or more. | <pre>Object</pre> |
| ecs_target<br/>.capacity_provider_strategy<br/>.base | (Optional) The base value designates how many tasks, at a minimum, to run on the specified capacity provider. Only one capacity provider in a capacity provider strategy can have a base defined. If no value is specified, the default value of 0 is used. | <pre>number</pre> |
| ecs_target<br/>.capacity_provider_strategy<br/>.capacity_provider | (Required) Short name of the capacity provider. | <pre>string</pre> |
| ecs_target<br/>.capacity_provider_strategy<br/>.weight | (Required) The weight value designates the relative percentage of the total number of tasks launched that should use the specified capacity provider. The weight value is taken into consideration after the base value, if defined, is satisfied. | <pre>number</pre> |
| ecs_target<br/>.enable_ecs_managed_tags | (Optional) Specifies whether to enable Amazon ECS managed tags for the task. | <pre>bool</pre> |
| ecs_target<br/>.enable_execute_command | (Optional) Whether or not to enable the execute command functionality for the containers in this task. If true, this enables execute command functionality on all containers in the task. | <pre>bool</pre> |
| ecs_target<br/>.launch_type | (Optional) Specifies the launch type on which your task is running. The launch type that you specify here must match one of the launch type (compatibilities) of the target task. Valid values include: 'EC2', 'EXTERNAL', or 'FARGATE'. | <pre>string</pre> |
| ecs_target<br/>.network_configuration | (Optional) Use this if the ECS task uses the awsvpc network mode. This specifies the VPC subnets and security groups associated with the task, and whether a public IP address is to be used. Required if 'launch\_type' is 'FARGATE' because the awsvpc mode is required for Fargate tasks. | <pre>Object</pre> |
| ecs_target<br/>.network_configuration<br/>.assign_public_ip | (Optional) Assign a public IP address to the ENI (Fargate launch type only). Valid values are 'true' or 'false'. Defaults to 'false'. | <pre>bool</pre> |
| ecs_target<br/>.network_configuration<br/>.security_groups | (Optional) The security groups associated with the task or service. If you do not specify a security group, the default security group for the VPC is used. | <pre>list(string)</pre> |
| ecs_target<br/>.network_configuration<br/>.subnets | (Required) The subnets associated with the task or service. | <pre>list(string)</pre> |
| ecs_target<br/>.placement_constraint | (Optional) An array of placement constraint objects to use for the task. You can specify up to 10 constraints per task (including constraints in the task definition and those specified at runtime). | <pre>list(string)</pre> |
| ecs_target<br/>.placement_constraint<br/>.expression | (Optional) Cluster Query Language expression to apply to the constraint. Does not need to be specified for the distinctInstance type. For more information, see [Cluster Query Language in the Amazon EC2 Container Service Developer Guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-query-language.html). | <pre>string</pre> |
| ecs_target<br/>.placement_constraint<br/>.type | (Required) Type of constraint. The only valid values at this time are 'memberOf' and 'distinctInstance'. | <pre>string</pre> |
| ecs_target<br/>.platform_version | (Optional) Specifies the platform version for the task. Specify only the numeric portion of the platform version, such as 1.1.0. This is used only if LaunchType is 'FARGATE'. For more information about valid platform versions, see [AWS Fargate Platform Versions](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/platform-fargate.html). | <pre>string</pre> |
| ecs_target<br/>.propagate_tags | (Optional) Specifies whether to propagate the tags from the task definition to the task. If no value is specified, the tags are not propagated. Tags can only be propagated to the task during task creation. The only valid value is: 'TASK\_DEFINITION'. | <pre>string</pre> |
| ecs_target<br/>.tags | (Optional) A map of tags to assign to ecs resources. This is a merged structure between these tags and 'var.tags'. | <pre>map(string)</pre> |
| ecs_target<br/>.task_count | (Optional) The number of tasks to create based on the TaskDefinition. The default is 1. | <pre>number</pre> |
| ecs_target<br/>.task_definition_arn | (Required) The ARN of the task definition to use if the event target is an Amazon ECS cluster. | <pre>string</pre> |
| http_target | (Optional) Parameters used when you are using the rule to invoke an API Gateway REST endpoint. A maximum of 1 is allowed. | <pre>object</pre> |
| http_target<br/>.header_parameters | (Optional) Enables you to specify HTTP headers to add to the request. | <pre>map(string)</pre> |
| http_target<br/>.path_parameter_values | (Optional) The list of values that correspond sequentially to any path variables in your endpoint ARN. | <pre>list(string)</pre> |
| http_target<br/>.query_string_parameters | (Optional) Represents keys/values of query string parameters that are appended to the invoked endpoint. | <pre>map(string)</pre> |
| input | (Optional) Valid JSON text passed to the target. Conflicts with 'input\_path' and 'input\_transformer'. | <pre>map(string)</pre> |
| input_path | (Optional) The value of the JSONPath that is used for extracting part of the matched event when passing it to the target. Conflicts with 'input' and 'input\_transformer'. | <pre>string</pre> |
| input_transformer | (Optional) Parameters used when you are providing a custom input to a target based on certain event data. Conflicts with 'input' and 'input\_path'. | <pre>object</pre> |
| input_transformer<br/>.input_paths | (Optional) Key value pairs specified in the form of JSONPath (for example, time = $.time). You can have as many as 100 key-value pairs. You must use JSON dot notation, not bracket notation. The keys can't start with "AWS". | <pre>string</pre> |
| input_transformer<br/>.input_template | (Required) Template to customize data sent to the target. Must be valid JSON. To send a string value, the string value must include double quotes. Values must be escaped for both JSON and Terraform, e.g., "\"Your string goes here.\\nA new line.\"" | <pre>string</pre> |
| kinesis_target | (Optional) Parameters used when you are using the rule to invoke an Amazon Kinesis Stream. A maximum of 1 are allowed. | <pre>object</pre> |
| kinesis_target<br/>.partition_key_path | (Optional) The JSON path to be extracted from the event and used as the partition key. | <pre>string</pre> |
| retry_policy | (Optional) Parameters used when you are providing retry policies. A maximum of 1 are allowed. | <pre>object</pre> |
| retry_policy<br/>.maximum_event_age_in_seconds | (Optional) The age in seconds to continue to make retry attempts. | <pre>number</pre> |
| retry_policy<br/>.maximum_retry_attempts | (Optional) maximum number of retry attempts to make before the request fails. | <pre>number</pre> |
| role_arn | (Optional) The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. Required if 'ecs\_target' is used or target in 'arn' is EC2 instance, Kinesis data stream, Step Functions state machine, or Event Bus in different account or region. | <pre>string</pre> |
| rule_key | The key which is the rule associated in the event rule variable. The event bus name associated is the same as its rule. | <pre>string</pre> |
| run_command_targets | (Optional) Parameters used when you are using the rule to invoke Amazon EC2 Run Command. A maximum of 5 are allowed. | <pre>object</pre> |
| run_command_targets<br/>.key | (Required) Can be either tag:tag-key or InstanceIds. | <pre>string</pre> |
| run_command_targets<br/>.values | (Required) If Key is tag:tag-key, Values is a list of tag values. If Key is InstanceIds, Values is a list of Amazon EC2 instance IDs. | <pre>list(string)</pre> |
| sqs_target | (Optional) Parameters used when you are using the rule to invoke an Amazon SQS Queue. A maximum of 1 are allowed. | <pre>object</pre> |
| sqs_target<br/>.message_group_id | (Optional) The FIFO message group ID to use as the target. | <pre>string</pre> |
| target_id | (Optional) The unique target assignment ID. If missing, will generate a random, unique id. | <pre>string</pre> |

### <a name="input_log_resource_policy"></a> [log\_resource\_policy](#input\_log\_resource\_policy)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| name | (Optional) Custom name of the resource policy. If not provided, the name would be '<var.name>-log\_policy<code>sequence</code>'. | <pre>string</pre> |
| policy_document | (Required) Details of the resource policy, including the identity of the principal that is enabled to put logs to this account. This is formatted as a JSON string. Maximum length of 5120 characters. | <pre>string</pre> |
| sequence | (Required if 'name' is not set) Number of the resource to be created. | <pre>string</pre> |

### <a name="input_log_streams"></a> [log\_streams](#input\_log\_streams)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| name | (Optional) The custom name of the log stream. Must not be longer than 512 characters and must not contain ':'. If not provided, the name would be '<var.name>-log\_stream<code>sequence</code>'. | <pre>string</pre> |
| sequence | (Required if 'name' is not set) Number of the resource to be created. | <pre>string</pre> |

### <a name="input_log_subscription_filter"></a> [log\_subscription\_filter](#input\_log\_subscription\_filter)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| destination_arn | (Required) The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN. | <pre>string</pre> |
| distribution | (Optional) The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are "Random" and "ByLogStream". | <pre>string</pre> |
| filter_pattern | (Required) A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. Use empty string "" to match everything. For more information, see the [Amazon CloudWatch Logs User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html). | <pre>string</pre> |
| name | (Optional) A name for the subscription filter. If not provided, the name would be '<var.name>-sub\_filter<code>sequence</code>'. | <pre>string</pre> |
| role_arn | (Optional) The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to deliver ingested log events to the destination. If you use Lambda as a destination, you should skip this argument and use 'aws\_lambda\_permission' resource for granting access from CloudWatch logs to the destination Lambda function. | <pre>string</pre> |
| sequence | (Required if 'name' is not set) Number of the resource to be created. | <pre>string</pre> |

### <a name="input_metric_alarms"></a> [metric\_alarms](#input\_metric\_alarms)

```hcl
any
```

| Name | Description | Type |
|------|-------------|------|
| actions_enabled | (Optional) Indicates whether or not actions should be executed during any changes to the alarm's state. Defaults to true. | <pre>string</pre> |
| alarm_actions | (Optional) The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN). | <pre>list(string)</pre> |
| alarm_description | (Optional) The description for the alarm. | <pre>string</pre> |
| comparison_operator | (Required) The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: GreaterThanOrEqualToThreshold, GreaterThanThreshold, LessThanThreshold, LessThanOrEqualToThreshold. Additionally, the values LessThanLowerOrGreaterThanUpperThreshold, LessThanLowerThreshold, and GreaterThanUpperThreshold are used only for alarms based on anomaly detection models. | <pre>string</pre> |
| datapoints_to_alarm | (Optional) The number of datapoints that must be breaching to trigger the alarm. | <pre>number</pre> |
| dimensions | (Optional) The dimensions for the alarm's associated metric. For the list of available dimensions see the AWS documentation [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). | <pre>map(string)</pre> |
| evaluate_low_sample_count_percentiles | (Optional) Used only for alarms based on percentiles. If you specify ignore, the alarm state will not change during periods with too few data points to be statistically significant. If you specify evaluate or omit this parameter, the alarm will always be evaluated and possibly change state no matter how many data points are available. The following values are supported: ignore, and evaluate. | <pre>string</pre> |
| evaluation_periods | (Required) The number of periods over which data is compared to the specified threshold. | <pre>number</pre> |
| extended_statistic | (Optional) The percentile statistic for the metric associated with the alarm. Specify a value between p0.0 and p100. :warning: If you specify at least one 'metric\_query' block, you may not specify a 'metric\_name', 'namespace', 'period' or 'statistic'. If you do not specify a 'metric\_query' block, you must specify each of these (although you may use 'extended\_statistic' instead of 'statistic'). | <pre>string</pre> |
| insufficient_data_actions | (Optional) The list of actions to execute when this alarm transitions into an INSUFFICIENT\_DATA state from any other state. Each action is specified as an Amazon Resource Name (ARN). | <pre>list(string)</pre> |
| metric_name | (Optional) The name for the alarm's associated metric. See docs for [supported metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). :warning: If you specify at least one 'metric\_query' block, you may not specify a 'metric\_name', 'namespace', 'period' or 'statistic'. If you do not specify a 'metric\_query' block, you must specify each of these (although you may use 'extended\_statistic' instead of 'statistic'). | <pre>string</pre> |
| metric_query | (Optional) Enables you to create an alarm based on a metric math expression. You may specify at most 20. :warning: If you specify at least one 'metric\_query' block, you may not specify a 'metric\_name', 'namespace', 'period' or 'statistic'. If you do not specify a 'metric\_query' block, you must specify each of these (although you may use 'extended\_statistic' instead of 'statistic'). | <pre>object</pre> |
| metric_query<br/>.account_id | (Optional) The ID of the account where the metrics are located, if this is a cross-account alarm. | <pre>number</pre> |
| metric_query<br/>.expression | (Optional) The math expression to be performed on the returned data, if this object is performing a math expression. This expression can use the id of the other metrics to refer to those metrics, and can also use the id of other expressions to use the result of those expressions. For more information about metric math expressions, see Metric Math Syntax and Functions in the [Amazon CloudWatch User Guide](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/using-metric-math.html#metric-math-syntax). :warning: You must specify either 'metric' or 'expression'. Not both. | <pre>string</pre> |
| metric_query<br/>.id | (Required) A short name used to tie this object to the results in the response. If you are performing math expressions on this set of data, this name represents that data and can serve as a variable in the mathematical expression. The valid characters are letters, numbers, and underscore. The first character must be a lowercase letter. | <pre>string</pre> |
| metric_query<br/>.label | (Optional) A human-readable label for this metric or expression. This is especially useful if this is an expression, so that you know what the value represents. | <pre>string</pre> |
| metric_query<br/>.metric | (Optional) The metric to be returned, along with statistics, period, and units. Use this parameter only if this object is retrieving a metric and not performing a math expression on returned data. :warning: You must specify either 'metric' or 'expression'. Not both. | <pre>object</pre> |
| metric_query<br/>.metric<br/>.dimensions | (Optional) The dimensions for this metric. For the list of available dimensions see the AWS documentation [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). | <pre>map(string)</pre> |
| metric_query<br/>.metric<br/>.metric_name | (Required) The name for this metric. See docs for [supported metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). | <pre>string</pre> |
| metric_query<br/>.metric<br/>.namespace | (Required) The namespace for this metric. See docs for the [list of namespaces](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). | <pre>string</pre> |
| metric_query<br/>.metric<br/>.period | (Required)  Granularity in seconds of returned data points. For metrics with regular resolution, valid values are any multiple of 60. For high-resolution metrics, valid values are 1, 5, 10, 30, or any multiple of 60. | <pre>number</pre> |
| metric_query<br/>.metric<br/>.stat | (Required) The statistic to apply to this metric. See docs for [supported statistics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Statistics-definitions.html). | <pre>string</pre> |
| metric_query<br/>.metric<br/>.unit | (Optional) The unit for this metric. | <pre>string</pre> |
| metric_query<br/>.return_data | (Optional) Specify exactly one 'metric\_query' to be 'true' to use that 'metric\_query' result as the alarm. | <pre>bool</pre> |
| name | (Optional) The descriptive name for the alarm. This name must be unique within the user's AWS account. If not provided, the name would be '<var.name>-metric\_alarm<code>sequence</code>'. | <pre>string</pre> |
| namespace | (Optional) The namespace for the alarm's associated metric. See docs for the [list of namespaces](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). :warning: If you specify at least one 'metric\_query' block, you may not specify a 'metric\_name', 'namespace', 'period' or 'statistic'. If you do not specify a 'metric\_query' block, you must specify each of these (although you may use 'extended\_statistic' instead of 'statistic'). | <pre>string</pre> |
| ok_actions | (Optional) The list of actions to execute when this alarm transitions into an OK state from any other state. Each action is specified as an Amazon Resource Name (ARN). | <pre>list(string)</pre> |
| period | (Optional) The period in seconds over which the specified statistic is applied. Valid values are 10, 30, or any multiple of 60. :warning: If you specify at least one 'metric\_query' block, you may not specify a 'metric\_name', 'namespace', 'period' or 'statistic'. If you do not specify a 'metric\_query' block, you must specify each of these (although you may use 'extended\_statistic' instead of 'statistic'). | <pre>number</pre> |
| sequence | (Required if 'name' is not set) Number of the resource to be created. | <pre>string</pre> |
| statistic | (Optional) The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum. :warning: If you specify at least one 'metric\_query' block, you may not specify a 'metric\_name', 'namespace', 'period' or 'statistic'. If you do not specify a 'metric\_query' block, you must specify each of these (although you may use 'extended\_statistic' instead of 'statistic'). | <pre>string</pre> |
| tags | (Optional) A map of tags to assign to the resource. This map will be merged with the common tags defined in the variable 'var.tags' and 'var.metric\_tags'. | <pre>map(string)</pre> |
| threshold | (Optional) The value against which the specified statistic is compared. This parameter is required for alarms based on static thresholds, but should not be used for alarms based on anomaly detection models. | <pre>string</pre> |
| threshold_metric_id | (Optional) If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY\_DETECTION\_BAND function. | <pre>string</pre> |
| treat_missing_data | (Optional) Sets how this alarm is to handle missing data points. The following values are supported: missing, ignore, breaching and notBreaching. Defaults to missing. | <pre>string</pre> |
| unit | (Optional) The unit for the alarm's associated metric. | <pre>string</pre> |

## Output example

```hcl
aws_logstorage = {
  "acw_default" = {
    "dashboards" = {
      "dashboard1" = {
        "dashboard_arn" = "arn:aws:cloudwatch::<aws_account_id>:dashboard/glnd1airacwtest001-dashboard001"
        "dashboard_body" = "{\"widgets\":[{\"type\":\"metric\",\"x\":0,\"y\":0,\"width\":12,\"height\":6,\"properties\":{\"metrics\":[[\"AWS/EC2\",\"CPUUtilization\",\"InstanceId\",\"i-0ae8b7af4ebd01bd1\"]],\"period\":300,\"stat\":\"Average\",\"region\":\"eu-west-1\",\"title\":\"EC2 Instance CPU\"}},{\"type\":\"text\",\"x\":0,\"y\":7,\"width\":3,\"height\":3,\"properties\":{\"markdown\":\"Dashboard 1 Test\"}},{\"type\":\"log\",\"x\":12,\"y\":24,\"width\":12,\"height\":6,\"properties\":{\"region\":\"eu-west-1\",\"title\":\"Errors (Application Log)\",\"query\":\"SOURCE 'glnd3airacwtest01gene001-log_group' | filter @message like \\\"[ERROR]\\\"\\n | fields @timestamp, @message | sort @timestamp desc | limit 20\",\"view\":\"table\"}}]}"
        "dashboard_name" = "glnd1airacwtest001-dashboard001"
        "id" = "glnd1airacwtest001-dashboard001"
      }
      "dashboard2" = {
        "dashboard_arn" = "arn:aws:cloudwatch::<aws_account_id>:dashboard/acwdashcustomname"
        "dashboard_body" = "{\"widgets\":[{\"type\":\"metric\",\"x\":0,\"y\":0,\"width\":12,\"height\":6,\"properties\":{\"metrics\":[[\"AWS/EC2\",\"CPUUtilization\",\"InstanceId\",\"i-012345\"]],\"period\":300,\"stat\":\"Average\",\"region\":\"eu-west-2\",\"title\":\"EC2 Instance CPU\"}},{\"type\":\"text\",\"x\":0,\"y\":7,\"width\":3,\"height\":3,\"properties\":{\"markdown\":\"Dashboard 2 Test\"}}]}"
        "dashboard_name" = "acwdashcustomname"
        "id" = "acwdashcustomname"
      }
    }
    "event_bus" = [
      {
        "arn" = "arn:aws:events:eu-west-1:<aws_account_id>:event-bus/glnd1airacwtest001-event_bus"
        "event_source_name" = null
        "id" = "glnd1airacwtest001-event_bus"
        "kms_key_identifier" = "arn:aws:kms:eu-west-1:<aws_account_id>:key/0c29a38c-5add-401e-8476-76ff61afa044"
        "name" = "glnd1airacwtest001-event_bus"
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
          "test" = "ACW Event Bus test tag"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
          "test" = "ACW Event Bus test tag"
        }
      },
    ]
    "event_bus_policies" = {
      "bus_policy_1" = {
        "event_bus_name" = "glnd1airacwtest001-event_bus"
        "id" = "glnd1airacwtest001-event_bus"
        "policy" = "{\"Statement\":[{\"Action\":[\"events:DescribeRule\",\"events:ListRules\",\"events:ListTargetsByRule\",\"events:ListTagsForResource\",\"events:PutEvents\"],\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":\"*\",\"Sid\":\"5\"}],\"Version\":\"2012-10-17\"}"
      }
      "bus_policy_2" = {
        "event_bus_name" = "default"
        "id" = "default"
        "policy" = "{\"Statement\":[{\"Action\":[\"events:DescribeRule\",\"events:ListRules\",\"events:PutEvents\"],\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":\"*\",\"Sid\":\"10\"}],\"Version\":\"2012-10-17\"}"
      }
    }
    "event_rules" = {
      "rule_1" = {
        "arn" = "arn:aws:events:eu-west-1:<aws_account_id>:rule/glnd1airacwtest001-event_bus/glnd1airacwtest001-event_rule001"
        "description" = "ACW - Test"
        "event_bus_name" = "glnd1airacwtest001-event_bus"
        "event_pattern" = "{\"detail\":{\"eventName\":[\"CreateVpc\"],\"eventSource\":[\"ec2.amazonaws.com\"]},\"detail-type\":[\"AWS API Call via CloudTrail\"],\"source\":[\"ec2.amazonaws.com\"]}"
        "force_destroy" = false
        "id" = "glnd1airacwtest001-event_bus/glnd1airacwtest001-event_rule001"
        "is_enabled" = true
        "name" = "glnd1airacwtest001-event_rule001"
        "name_prefix" = ""
        "role_arn" = ""
        "schedule_expression" = ""
        "state" = "ENABLED"
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
          "test" = "ACW Event Rules test tag"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
          "test" = "ACW Event Rules test tag"
        }
      }
    }
    "event_targets" = {
      "sqs" = {
        "appsync_target" = []
        "arn" = "arn:aws:sqs:eu-west-1:<aws_account_id>:glnd1airsqsas3t01gene002"
        "batch_target" = []
        "dead_letter_config" = []
        "ecs_target" = []
        "event_bus_name" = "glnd1airacwtest001-event_bus"
        "force_destroy" = false
        "http_target" = []
        "id" = "glnd1airacwtest001-event_bus-glnd1airacwtest001-event_rule001-Test"
        "input" = ""
        "input_path" = ""
        "input_transformer" = []
        "kinesis_target" = []
        "redshift_target" = []
        "retry_policy" = [
          {
            "maximum_event_age_in_seconds" = null
            "maximum_retry_attempts" = null
          },
        ]
        "role_arn" = ""
        "rule" = "glnd1airacwtest001-event_rule001"
        "run_command_targets" = []
        "sagemaker_pipeline_target" = []
        "sqs_target" = []
        "target_id" = "Test"
      }
    }
    "log_groups" = null
    "log_resource_policies" = {
      "log_policy1" = "glnd1airacwtest001-log_policy001"
      "log_policy2" = "acwlogpolcustomname"
      "log_policy3" = "glnd1airacwtest001-log_policy003"
    }
    "log_streams" = {
      "log_stream1" = {
        "arn" = "arn:aws:logs:eu-west-1:<aws_account_id>:log-group:glnd1airacwtest001-log_group:log-stream:glnd1airacwtest001-log_stream001"
        "id" = "glnd1airacwtest001-log_stream001"
        "log_group_name" = "glnd1airacwtest001-log_group"
        "name" = "glnd1airacwtest001-log_stream001"
      }
      "log_stream2" = {
        "arn" = "arn:aws:logs:eu-west-1:<aws_account_id>:log-group:glnd1airacwtest001-log_group:log-stream:aclogstreamcustomname"
        "id" = "aclogstreamcustomname"
        "log_group_name" = "glnd1airacwtest001-log_group"
        "name" = "aclogstreamcustomname"
      }
    }
    "log_subscription_filters" = {}
    "metric_alarms" = {
      "metric_1" = {
        "actions_enabled" = true
        "alarm_actions" = null
        "alarm_description" = "Test"
        "alarm_name" = "glnd1airacwtest001-metric_alarm001"
        "arn" = "arn:aws:cloudwatch:eu-west-1:<aws_account_id>:alarm:glnd1airacwtest001-metric_alarm001"
        "comparison_operator" = "GreaterThanOrEqualToThreshold"
        "datapoints_to_alarm" = 1
        "dimensions" = null
        "evaluate_low_sample_count_percentiles" = ""
        "evaluation_periods" = 2
        "extended_statistic" = ""
        "id" = "glnd1airacwtest001-metric_alarm001"
        "insufficient_data_actions" = null
        "metric_name" = "CPUUtilization"
        "metric_query" = []
        "namespace" = "TEST/GLN"
        "ok_actions" = null
        "period" = 120
        "statistic" = "Average"
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
        }
        "threshold" = 0
        "threshold_metric_id" = ""
        "treat_missing_data" = "missing"
        "unit" = "Count"
      }
      "metric_2" = {
        "actions_enabled" = true
        "alarm_actions" = null
        "alarm_description" = "Test"
        "alarm_name" = "acwmetricustomname"
        "arn" = "arn:aws:cloudwatch:eu-west-1:<aws_account_id>:alarm:acwmetricustomname"
        "comparison_operator" = "GreaterThanUpperThreshold"
        "datapoints_to_alarm" = 1
        "dimensions" = null
        "evaluate_low_sample_count_percentiles" = ""
        "evaluation_periods" = 1
        "extended_statistic" = ""
        "id" = "acwmetricustomname"
        "insufficient_data_actions" = null
        "metric_name" = ""
        "metric_query" = [
          {
            "account_id" = "<aws_account_id>"
            "expression" = ""
            "id" = "m1"
            "label" = "CPUUtilization (Expected)"
            "metric" = [
              {
                "dimensions" = {
                  "InstanceId" = "i-abc123"
                }
                "metric_name" = "CPUUtilization"
                "namespace" = "AWS/EC2"
                "period" = 120
                "stat" = "Average"
                "unit" = "Count"
              },
            ]
            "period" = null
            "return_data" = true
          },
          {
            "account_id" = "<aws_account_id>"
            "expression" = "ANOMALY_DETECTION_BAND(m1)"
            "id" = "a1"
            "label" = "CPUUtilization (Expected)"
            "metric" = []
            "period" = null
            "return_data" = true
          },
        ]
        "namespace" = ""
        "ok_actions" = null
        "period" = 0
        "statistic" = ""
        "tags" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
        }
        "tags_all" = {
          "environment" = "dev"
          "product" = "Gluon AWS CloudWatch"
          "project" = "Gluon"
        }
        "threshold" = 0
        "threshold_metric_id" = "a1"
        "treat_missing_data" = "missing"
        "unit" = ""
      }
    }
  }
}
```

## Outputs list

| Name| Output value | Description |
|:--|:--|:--|
|aws_logstorage|module.aws_logstorage|AWS Log Storage outputs map. <br>[Map AWS Log Storage Outputs](#AWS Log Storage Outputs). |

<a name="AWS Log Storage Outputs"></a>

### AWS Log Storage Outputs

| Name | Description | Type |
|------|-------------|------|
| [dashboards](#output_dashboards) | CloudWatch Dashboards outputs. | <pre>module.aws_logstorage.dashboards</pre> |
| [event_bus](#output_event_bus) | Cloud Watch Event Bus outputs. | <pre>module.aws_logstorage.event_bus</pre> |
| [event_bus_policies](#output_event_bus_policies) | Cloud Watch Event Bus Policy outputs. | <pre>module.aws_logstorage.event_bus_policies</pre> |
| [event_rules](#output_event_rules) | Cloud Watch Event Rule outputs. | <pre>module.aws_logstorage.event_rules</pre> |
| [event_targets](#output_event_targets) | Cloud Watch Event Target outputs. | <pre>module.aws_logstorage.event_targets</pre> |
| [log_group](#output_log_group) | CloudWatch Log Group outputs. | <pre>module.aws_logstorage.log_group</pre> |
| [log_resource_policies](#output_log_resource_policies) | Cloud Watch Log Resource policy outputs. | <pre>module.aws_logstorage.log_resource_policies</pre> |
| [log_streams](#output_log_streams) | CloudWatch Log Streams outputs. | <pre>module.aws_logstorage.log_streams</pre> |
| [log_subscription_filters](#output_log_subscription_filters) | Cloud Watch Log Subscription Filter outputs. | <pre>module.aws_logstorage.log_subscription_filters</pre> |
| [metric_alarms](#output_metric_alarms) | CloudWatch Metric Alarm outputs. | <pre>module.aws_logstorage.metric_alarms</pre> |

### Block Parameters

#### <a name="output_dashboards"></a> [dashboards](#output\_dashboards)

| Name | Description | Type |
|------|-------------|------|
| dashboard\_arn | The Amazon Resource Name (ARN) of the dashboard. | <pre>module.aws_logstorage.dashboards.dashboard\_arn</pre> |
| dashboard\_body | The detailed information about the dashboard, including what widgets are included and their location on the dashboard. You can read more about the body structure in the [documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html). | <pre>module.aws_logstorage.dashboards.dashboard\_body</pre> |
| dashboard\_name | The name of the dashboard. | <pre>module.aws_logstorage.dashboards.dashboard\_name</pre> |
| id | The ID of the dashboard. | <pre>module.aws_logstorage.dashboards.id</pre> |

#### <a name="output_event_bus"></a> [event\_bus](#output\_event\_bus)

| Name | Description | Type |
|------|-------------|------|
| arn | The Amazon Resource Name (ARN) of the event bus. | <pre>module.aws_logstorage.event_bus.arn</pre> |
| event\_source\_name | The partner event source that the new event bus will be matched with. | <pre>module.aws_logstorage.event_bus.event_source_name</pre> |
| id | The ID of the event bus. | <pre>module.aws_logstorage.event_bus.id</pre> |
| kms\_key\_identifier | The identifier of the AWS KMS customer managed key used to encrypt EventBridge, if you choose to use a customer managed key to encrypt events on this event bus. | <pre>module.aws_logstorage.event_bus.kms_key_identifier</pre> |
| name | The name of the created event bus. | <pre>module.aws_logstorage.event_bus.name</pre> |
| tags | A map of tags to assign to the resource. | <pre>module.aws_logstorage.event_bus.tags</pre> |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_logstorage.event_bus.tags_all</pre> |

#### <a name="output_event_bus_policies"></a> [event\_bus\_policies](#output\_event\_bus\_policies)

| Name | Description | Type |
|------|-------------|------|
| event\_bus\_name | The name of the event bus where the policy was applied. | <pre>module.aws_logstorage.event_bus_policies.event_bus_name</pre> |
| id | The name of the EventBridge event bus. | <pre>module.aws_logstorage.event_bus_policies.id</pre> |
| policy | The text of the policy. | <pre>module.aws_logstorage.event_bus_policies.policy</pre> |

#### <a name="output_event_rules"></a> [event\_rules](#output\_event\_rules)

| Name | Description | Type |
|------|-------------|------|
| arn | The Amazon Resource Name (ARN) of the rule. | <pre>module.aws_logstorage.event_rules.arn</pre> |
| description | The description of the rule. | <pre>module.aws_logstorage.event_rules.description</pre> |
| event\_bus\_name | The name or ARN of the event bus associated with this rule. | <pre>module.aws_logstorage.event_rules.event_bus_name</pre> |
| event\_pattern | The event pattern described a JSON object. | <pre>module.aws_logstorage.event_rules.event_pattern</pre> |
| id | The name of the rule. | <pre>module.aws_logstorage.event_rules.id</pre> |
| name | The name of the rule. | <pre>module.aws_logstorage.event_rules.name</pre> |
| role\_arn | The Amazon Resource Name (ARN) associated with the role that is used for target invocation. | <pre>module.aws_logstorage.event_rules.role_arn</pre> |
| schedule\_expression | The scheduling expression. | <pre>module.aws_logstorage.event_rules.schedule_expression</pre> |
| state | State of the rule. | <pre>module.aws_logstorage.event_rules.state</pre> |
| tags | A map of tags assigned to the resource. | <pre>module.aws_logstorage.event_rules.tags</pre> |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_logstorage.event_rules.tags\_all</pre> |

#### <a name="output_event_targets"></a> [event\_targets](#output\_event\_targets)

| Name | Description | Type |
|------|-------------|------|
| arn | The Amazon Resource Name (ARN) of the target. | <pre>module.aws_logstorage.event_targets.arn</pre> |
| batch\_target | Parameters used when you are using the rule to invoke an Amazon Batch Job. | <pre>module.aws_logstorage.event_targets.batch_target</pre> |
| batch\_target<br/>.array\_size | The size of the array, if this is an array batch job. | <pre>module.aws_logstorage.event_targets.batch_target.array_size</pre> |
| batch\_target<br/>.job\_attempts | The number of times to attempt to retry, if the job fails. | <pre>module.aws_logstorage.event_targets.batch_target.job_attempts</pre> |
| batch\_target<br/>.job\_definition | The ARN or name of the job definition used if the event target is an AWS Batch job. | <pre>module.aws_logstorage.event_targets.batch_target.job_definition</pre> |
| batch\_target<br/>.job\_name | The name used for this execution of the job, if the target is an AWS Batch job. | <pre>module.aws_logstorage.event_targets.batch_target.job_name</pre> |
| cloudwatch\_event\_target\_event\_bus\_name | The name or ARN of the event bus associated with the rule. | <pre>module.aws_logstorage.event_targets.event_bus_name</pre> |
| cloudwatch\_event\_target\_role\_arn | The Amazon Resource Name (ARN) of the IAM role used for this target when the rule is triggered. | <pre>module.aws_logstorage.event_targets.role_arn</pre> |
| dead\_letter\_config | Parameters used when you are providing a dead letter config. | <pre>module.aws_logstorage.event_targets.dead_letter_config</pre> |
| ecs\_target | Parameters used when you are using the rule to invoke Amazon ECS Task. | <pre>module.aws_logstorage.event_targets.ecs_target</pre> |
| ecs\_target<br/>.capacity\_provider\_strategy | The capacity provider strategy used for the task. | <pre>module.aws_logstorage.event_targets.ecs_target.capacity_provider_strategy</pre> |
| ecs\_target<br/>.capacity\_provider\_strategy<br/>.base | The base value designates how many tasks, at a minimum, to run on the specified capacity provider. | <pre>module.aws_logstorage.event_targets.ecs_target.capacity_provider_strategy.base</pre> |
| ecs\_target<br/>.capacity\_provider\_strategy<br/>.capacity\_provider | Short name of the capacity provider. | <pre>module.aws_logstorage.event_targets.ecs_target.capacity_provider_strategy.capacity_provider</pre> |
| ecs\_target<br/>.capacity\_provider\_strategy<br/>.weight | The weight value designates the relative percentage of the total number of tasks launched that should use the specified capacity provider. | <pre>module.aws_logstorage.event_targets.ecs_target.capacity_provider_strategy.weight</pre> |
| ecs\_target<br/>.enable\_ecs\_managed\_tags | Specifies whether to enable Amazon ECS managed tags for the task. | <pre>module.aws_logstorage.event_targets.ecs_target.enable_ecs_managed_tags</pre> |
| ecs\_target<br/>.enable\_execute\_command | Whether or not to enable the execute command functionality for the containers in this task. | <pre>module.aws_logstorage.event_targets.ecs_target.enable_execute_command</pre> |
| ecs\_target<br/>.group | Specifies an ECS task group for the task. | <pre>module.aws_logstorage.event_targets.ecs_target.group</pre> |
| ecs\_target<br/>.launch\_type | Specifies the launch type on which your task is running. | <pre>module.aws_logstorage.event_targets.ecs_target.launch_type</pre> |
| ecs\_target<br/>.network\_configuration | Specifies the VPC subnets and security groups associated with the task, and whether a public IP address is to be used. | <pre>module.aws_logstorage.event_targets.ecs_target.network_configuration</pre> |
| ecs\_target<br/>.network\_configuration<br/>.assign\_public\_ip | Assign a public IP address to the ENI. | <pre>module.aws_logstorage.event_targets.ecs_target.network_configuration.assign_public_ip</pre> |
| ecs\_target<br/>.network\_configuration<br/>.security\_groups | The security groups associated with the task or service. | <pre>module.aws_logstorage.event_targets.ecs_target.network_configuration.security_groups</pre> |
| ecs\_target<br/>.network\_configuration<br/>.subnets | The subnets associated with the task or service. | <pre>module.aws_logstorage.event_targets.ecs_target.network_configuration.subnets</pre> |
| ecs\_target<br/>.ordered\_placement\_strategy | An array of placement strategy objects to use for the task. | <pre>module.aws_logstorage.event_targets.ecs_target.ordered_placement_strategy</pre> |
| ecs\_target<br/>.ordered\_placement\_strategy<br/>.field | The field to apply the placement strategy against. | <pre>module.aws_logstorage.event_targets.ecs_target.ordered_placement_strategy.field</pre> |
| ecs\_target<br/>.ordered\_placement\_strategy<br/>.type | Type of placement strategy. | <pre>module.aws_logstorage.event_targets.ecs_target.ordered_placement_strategy.type</pre> |
| ecs\_target<br/>.placement\_constraint | An array of placement constraint objects to use for the task. | <pre>module.aws_logstorage.event_targets.ecs_target.placement_constraint</pre> |
| ecs\_target<br/>.placement\_constraint<br/>.expression | Cluster Query Language expression to apply to the constraint. | <pre>module.aws_logstorage.event_targets.ecs_target.placement_constraint.expression</pre> |
| ecs\_target<br/>.placement\_constraint<br/>.type | Type of constraint. | <pre>module.aws_logstorage.event_targets.ecs_target.placement_constraint.type</pre> |
| ecs\_target<br/>.platform\_version | Specifies the platform version for the task. | <pre>module.aws_logstorage.event_targets.ecs_target.platform_version</pre> |
| ecs\_target<br/>.propagate\_tags | Specifies whether to propagate the tags from the task definition to the task. | <pre>module.aws_logstorage.event_targets.ecs_target.propagate_tags</pre> |
| ecs\_target<br/>.tags | A map of tags assigned to ECS resources. | <pre>module.aws_logstorage.event_targets.ecs_target.tags</pre> |
| ecs\_target<br/>.task\_count | The number of tasks created based on the 'TaskDefinition'. | <pre>module.aws_logstorage.event_targets.ecs_target.task_count</pre> |
| ecs\_target<br/>.task\_definition\_arn | The ARN of the task definition to use if the event target is an Amazon ECS cluster. | <pre>module.aws_logstorage.event_targets.ecs_target.task_definition_arn</pre> |
| http\_target | Parameters used when you are using the rule to invoke an API Gateway REST endpoint. | <pre>module.aws_logstorage.event_targets.http_target</pre> |
| http\_target<br/>.header\_parameters | Enables you to specify HTTP headers to add to the request. | <pre>module.aws_logstorage.event_targets.http_target.header_parameters</pre> |
| http\_target<br/>.path\_parameter\_values | The list of values that correspond sequentially to any path variables in your endpoint ARN. | <pre>module.aws_logstorage.event_targets.http_target.path_parameter_values</pre> |
| http\_target<br/>.query\_string\_parameters | Represents keys/values of query string parameters that are appended to the invoked endpoint. | <pre>module.aws_logstorage.event_targets.http_target.query_string_parameters</pre> |
| input | Valid JSON text passed to the target. | <pre>module.aws_logstorage.event_targets.input</pre> |
| input\_path | The value of the JSONPaththat is used for extracting part of the matched event when passing it to the target. | <pre>module.aws_logstorage.event_targets.input_path</pre> |
| input\_transformer | Parameters used when you are providing a custom input to a target based on certain event data. | <pre>module.aws_logstorage.event_targets.input_transformer</pre> |
| kinesis\_target | Parameters used when you are using the rule to invoke an Amazon Kinesis Stream. | <pre>module.aws_logstorage.event_targets.kinesis_target</pre> |
| kinesis\_target<br/>.partition\_key\_path | The JSON path to be extracted from the event and used as the partition key. | <pre>module.aws_logstorage.event_targets.kinesis_target.partition_key_path</pre> |
| retry\_policy | Parameters used when you are providing retry policies. | <pre>module.aws_logstorage.event_targets.retry_policy</pre> |
| rule | The name of the rule you want to add targets to. | <pre>module.aws_logstorage.event_targets.rule</pre> |
| run\_command\_targets | Parameters used when you are using the rule to invoke Amazon EC2 Run Command. | <pre>module.aws_logstorage.event_targets.run_command_targets</pre> |
| run\_command\_targets<br/>.key | Can be either tag:tag-keyor InstanceIds. | <pre>module.aws_logstorage.event_targets.run_command_targets.key</pre> |
| run\_command\_targets<br/>.values | If Key is tag:tag-key, Values is a list of tag values. If Key is InstanceIds, Values is a list of Amazon EC2 instance IDs. | <pre>module.aws_logstorage.event_targets.run_command_targets.values</pre> |
| sqs\_target | Parameters used when you are using the rule to invoke an Amazon SQS Queue. | <pre>module.aws_logstorage.event_targets.sqs_target</pre> |
| sqs\_target<br/>.message\_group\_id | The FIFO message group ID to use as the target. | <pre>module.aws_logstorage.event_targets.sqs_target.message_group_id</pre> |
| target\_id | The unique target assignment ID. | <pre>module.aws_logstorage.event_targets.target_id</pre> |

#### <a name="output_log_group"></a> [log\_group](#output\_log\_group)

| Name | Description | Type |
|------|-------------|------|
| arn | The Amazon Resource Name (ARN) specifying the log group. Any :* suffix added by the API, denoting all CloudWatch Log Streams under the CloudWatch Log Group, is removed for greater compatibility with other AWS services that do not accept the suffix. | <pre>module.aws_logstorage.log_group.arn</pre> |
| kms\_key\_id | The ARN of the KMS Key to use when encrypting log data. | <pre>module.aws_logstorage.log_group.kms_key_id</pre> |
| name | The name of the log group. | <pre>module.aws_logstorage.log_group.name</pre> |
| name\_prefix | Creates a unique name beginning with the specified prefix. | <pre>module.aws_logstorage.log_group.name_prefix</pre> |
| retention\_in\_days | Specifies the number of days you want to retain log events in the specified log group. | <pre>module.aws_logstorage.log_group.retention_in_days</pre> |
| skip\_destroy | Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state. | <pre>module.aws_logstorage.log_group.skip_destroy</pre> |
| tags | A map of tags assigned to the resource. | <pre>module.aws_logstorage.log_group.tags</pre> |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_logstorage.log_group.tags_all</pre> |

#### <a name="output_log_resource_policies"></a> [log\_resource\_policies](#output\_log\_resource\_policies)

| Name | Description | Type |
|------|-------------|------|
| id | The name of the CloudWatch log resource policy. | <pre>module.aws_logstorage.log_resource_policies.id</pre> |
| policy\_document | Details of the resource policy, including the identity of the principal that is enabled to put logs to this account. | <pre>module.aws_logstorage.log_resource_policies.policy_document</pre> |
| policy\_name | The name of the CloudWatch log resource policy. | <pre>module.aws_logstorage.log_resource_policies.policy_name</pre> |

#### <a name="output_log_streams"></a> [log\_streams](#output\_log\_streams)

| Name | Description | Type |
|------|-------------|------|
| arn | The Amazon Resource Name (ARN) specifying the log stream. | <pre>module.aws_logstorage.log_streams.arn</pre> |
| log\_group\_name | The name of the log group under which the log stream is created. | <pre>module.aws_logstorage.log_streams.log_group_name</pre> |
| name | The name of the log stream. | <pre>module.aws_logstorage.log_streams.name</pre> |

#### <a name="output_log_subscription_filters"></a> [log\_subscription\_filters](#output\_log\_subscription\_filters)

| Name | Description | Type |
|------|-------------|------|
| destination\_arn | The ARN of the destination to deliver matching log events to. | <pre>module.aws_logstorage.log_subscription_filters.destination_arn</pre> |
| distribution | The method used to distribute log data to the destination. | <pre>module.aws_logstorage.log_subscription_filters.distribution</pre> |
| filter\_pattern | A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. | <pre>module.aws_logstorage.log_subscription_filters.filter_pattern</pre> |
| log\_group\_name | The name of the log group to associate the subscription filter with. | <pre>module.aws_logstorage.log_subscription_filters.log_group_name</pre> |
| name | The name for the subscription filter. | <pre>module.aws_logstorage.log_subscription_filters.name</pre> |
| role\_arn | The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to deliver ingested log events to the destination. | <pre>module.aws_logstorage.log_subscription_filters.role_arn</pre> |

#### <a name="output_metric_alarms"></a> [metric\_alarms](#output\_metric\_alarms)

| Name | Description | Type |
|------|-------------|------|
| actions\_enabled | Indicates whether or not actions should be executed during any changes to the alarm's state. | <pre>module.aws_logstorage.metric_alarms.actions_enabled</pre> |
| alarm\_actions | The list of actions to execute when this alarm transitions into an ALARM state from any other state. | <pre>module.aws_logstorage.metric_alarms.alarm_actions</pre> |
| alarm\_description | The description for the alarm. | <pre>module.aws_logstorage.metric_alarms.alarm_description</pre> |
| alarm\_name | The descriptive name for the alarm. | <pre>module.aws_logstorage.metric_alarms.alarm_name</pre> |
| arn | The ARN of the CloudWatch Metric Alarm. | <pre>module.aws_logstorage.metric_alarms.arn</pre> |
| comparison\_operator | The arithmetic operation used when comparing the specified Statistic and Threshold. | <pre>module.aws_logstorage.metric_alarms.comparison_operator</pre> |
| datapoints\_to\_alarm | The number of datapoints that must be breaching to trigger the alarm. | <pre>module.aws_logstorage.metric_alarms.datapoints_to_alarm</pre> |
| dimensions | The dimensions for the alarm's associated metric. | <pre>module.aws_logstorage.metric_alarms.dimensions</pre> |
| evaluate\_low\_sample\_count\_percentiles | Used only for alarms based on percentiles. | <pre>module.aws_logstorage.metric_alarms.evaluate_low_sample_count_percentiles</pre> |
| evaluation\_periods | The number of periods over which data is compared to the specified threshold. | <pre>module.aws_logstorage.metric_alarms.evaluation_periods</pre> |
| extended\_statistic | The percentile statistic for the metric associated with the alarm. Specify a value between p0.0 and p100. | <pre>module.aws_logstorage.metric_alarms.extended_statistic</pre> |
| id | The ID of the health check. | <pre>module.aws_logstorage.metric_alarms.id</pre> |
| insufficient\_data\_actions | The list of actions to execute when this alarm transitions into an INSUFFICIENT\_DATA state from any other state. | <pre>module.aws_logstorage.metric_alarms.insufficient_data_actions</pre> |
| metric\_name | The name for the alarm's associated metric. | <pre>module.aws_logstorage.metric_alarms.metric_name</pre> |
| metric\_query | Enables you to create an alarm based on a metric math expression. | <pre>module.aws_logstorage.metric_alarms.metric_query</pre> |
| namespace | The namespace for the alarm's associated metric. | <pre>module.aws_logstorage.metric_alarms.namespace</pre> |
| ok\_actions | The list of actions to execute when this alarm transitions into an OK state from any other state. | <pre>module.aws_logstorage.metric_alarms.ok_actions</pre> |
| period | The period in seconds over which the specified statisticis applied. | <pre>module.aws_logstorage.metric_alarms.period</pre> |
| statistic | The statistic to apply to the alarm's associated metric. | <pre>module.aws_logstorage.metric_alarms.statistic</pre> |
| tags | A map of tags to assign to the resource. If configured with a providerdefault\_tagsconfiguration blockpresent, tags with matching keys will overwrite those defined at the provider-level. | <pre>module.aws_logstorage.metric_alarms.tags</pre> |
| tags\_all | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. | <pre>module.aws_logstorage.metric_alarms.tags_all</pre> |
| threshold | The value against which the specified statistic is compared. | <pre>module.aws_logstorage.metric_alarms.threshold</pre> |
| threshold\_metric\_id | If this is an alarm based on an anomaly detection model, make this value match the ID of the ANOMALY\_DETECTION\_BAND function. | <pre>module.aws_logstorage.metric_alarms.threshold_metric_id</pre> |
| treat\_missing\_data | Sets how this alarm is to handle missing data points. | <pre>module.aws_logstorage.metric_alarms.treat_missing_data</pre> |
| unit | The unit for the alarm's associated metric. | <pre>module.aws_logstorage.metric_alarms.unit</pre> |

## Known Issues

### At deployment time of this terraform archetype

|Error|Description|Workaround|
|--|:-|--|
|Writing CloudWatch log resource policy failed: LimitExceededException: Resource limit exceeded.|This happens because Up to 10 CloudWatch Logs resource policies are allowed per Region per account. This quota can't be changed.|Use a policy with multiples statements.|
