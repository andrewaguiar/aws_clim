require 'json'
require 'open3'

class AwsClim
  def initialize(profile = 'default', global_options = {})
    @profile = profile
    @global_options = global_options
  end

  %w(
    accessanalyzer
    account
    acm
    acm-pca
    alexaforbusiness
    amp
    amplify
    amplifybackend
    amplifyuibuilder
    apigateway
    apigatewaymanagementapi
    apigatewayv2
    appconfig
    appconfigdata
    appflow
    appintegrations
    application-autoscaling
    application-insights
    applicationcostprofiler
    appmesh
    apprunner
    appstream
    appsync
    athena
    auditmanager
    autoscaling
    autoscaling-plans
    backup
    backup-gateway
    backupstorage
    batch
    billingconductor
    braket
    budgets
    ce
    chime
    chime-sdk-identity
    chime-sdk-media-pipelines
    chime-sdk-meetings
    chime-sdk-messaging
    cloud9
    cloudcontrol
    clouddirectory
    cloudformation
    cloudfront
    cloudhsm
    cloudhsmv2
    cloudsearch
    cloudsearchdomain
    cloudtrail
    cloudwatch
    codeartifact
    codebuild
    codecommit
    codeguru-reviewer
    codeguruprofiler
    codepipeline
    codestar
    codestar-connections
    codestar-notifications
    cognito-identity
    cognito-idp
    cognito-sync
    comprehend
    comprehendmedical
    compute-optimizer
    configservice
    configure
    connect
    connect-contact-lens
    connectcampaigns
    connectparticipant
    controltower
    cur
    customer-profiles
    databrew
    dataexchange
    datapipeline
    datasync
    dax
    deploy
    detective
    devicefarm
    devops-guru
    directconnect
    discovery
    dlm
    dms
    docdb
    drs
    ds
    dynamodb
    dynamodbstreams
    ebs
    ec2
    ec2-instance-connect
    ecr
    ecr-public
    ecs
    efs
    eks
    elastic-inference
    elasticache
    elasticbeanstalk
    elastictranscoder
    elb
    elbv2
    emr
    emr-containers
    emr-serverless
    es
    events
    evidently
    finspace
    finspace-data
    firehose
    fis
    fms
    forecast
    forecastquery
    frauddetector
    fsx
    gamelift
    gamesparks
    glacier
    globalaccelerator
    glue
    grafana
    greengrass
    greengrassv2
    groundstation
    guardduty
    health
    healthlake
    history
    honeycode
    iam
    identitystore
    imagebuilder
    importexport
    inspector
    inspector2
    iot
    iot-data
    iot-jobs-data
    iot1click-devices
    iot1click-projects
    iotanalytics
    iotdeviceadvisor
    iotevents
    iotevents-data
    iotfleethub
    iotsecuretunneling
    iotsitewise
    iotthingsgraph
    iottwinmaker
    iotwireless
    ivs
    ivschat
    kafka
    kafkaconnect
    kendra
    keyspaces
    kinesis
    kinesis-video-archived-media
    kinesis-video-media
    kinesis-video-signaling
    kinesisanalytics
    kinesisanalyticsv2
    kinesisvideo
    kms
    lakeformation
    lambda
    lex-models
    lex-runtime
    lexv2-models
    lexv2-runtime
    license-manager
    license-manager-user-subscriptions
    lightsail
    location
    logs
    lookoutequipment
    lookoutmetrics
    lookoutvision
    m2
    machinelearning
    macie
    macie2
    managedblockchain
    marketplace-catalog
    marketplace-entitlement
    marketplacecommerceanalytics
    mediaconnect
    mediaconvert
    medialive
    mediapackage
    mediapackage-vod
    mediastore
    mediastore-data
    mediatailor
    memorydb
    meteringmarketplace
    mgh
    mgn
    migration-hub-refactor-spaces
    migrationhub-config
    migrationhubstrategy
    mobile
    mq
    mturk
    mwaa
    neptune
    network-firewall
    networkmanager
    nimble
    opensearch
    opsworks
    opsworks-cm
    organizations
    outposts
    panorama
    personalize
    personalize-events
    personalize-runtime
    pi
    pinpoint
    pinpoint-email
    pinpoint-sms-voice
    pinpoint-sms-voice-v2
    polly
    pricing
    privatenetworks
    proton
    qldb
    qldb-session
    quicksight
    ram
    rbin
    rds
    rds-data
    redshift
    redshift-data
    redshift-serverless
    rekognition
    resiliencehub
    resource-groups
    resourcegroupstaggingapi
    robomaker
    rolesanywhere
    route53
    route53-recovery-cluster
    route53-recovery-control-config
    route53-recovery-readiness
    route53domains
    route53resolver
    rum
    s3
    s3api
    s3control
    s3outposts
    sagemaker
    sagemaker-a2i-runtime
    sagemaker-edge
    sagemaker-featurestore-runtime
    sagemaker-runtime
    savingsplans
    schemas
    sdb
    secretsmanager
    securityhub
    serverlessrepo
    service-quotas
    servicecatalog
    servicecatalog-appregistry
    servicediscovery
    ses
    sesv2
    shield
    signer
    sms
    snow-device-management
    snowball
    sns
    sqs
    ssm
    ssm-contacts
    ssm-incidents
    sso
    sso-admin
    sso-oidc
    stepfunctions
    storagegateway
    sts
    support
    support-app
    swf
    synthetics
    textract
    timestream-query
    timestream-write
    transcribe
    transfer
    translate
    voice-id
    waf
    waf-regional
    wafv2
    wellarchitected
    wisdom
    workdocs
    worklink
    workmail
    workmailmessageflow
    workspaces
    workspaces-web
    xray
  ).each do |service_name|
    define_method service_name do |*ps|
      execute(service_name, ps)
    end
  end

  private

  def execute(service, options)
    cmd = "aws #{service} #{option_to_s(options)} --profile=#{@profile}"

    out, err, status = Open3.capture3(cmd)

    if status.success?
      JSON.parse(out)
    else
      { 'error' => true, message: err }
    end
  end

  def option_to_s(options)
    if options.is_a?(String)
      options

    elsif options.is_a?(Array)
      options.map { |option|
        (option.is_a?(Array) ? "--#{option[0]}=\"#{option[1]}\"" : option)
      }.join(' ')
    end
  end
end

aws = AwsClim.new(ARGV[0])

# Find RestApi

puts "### Find RestApi "

rest_api = aws.apigateway('get-rest-apis')['items'].find do |item|
  item['tags']['aws:cloudformation:stack-name'].start_with?('transferless')
end

puts rest_api

puts "\n### Find Resource "

resource = aws.apigateway('get-resources', ['rest-api-id', rest_api['id']])['items'].find do |item|
  item['path'] == "/wallet/{walletId}" && item['resourceMethods'].include?('GET')
end

puts resource

puts "\n### Adding Method Response "

puts aws.apigateway(
  'put-method-response',
  ['rest-api-id', rest_api['id']],
  ['resource-id', resource['id']],
  ['http-method', 'GET'],
  ['status-code', '200'],
  ['response-parameters','method.response.header.access-control-allow-origin=false']
)



