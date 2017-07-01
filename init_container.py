#!/usr/bin/env python3
import os
import datetime

def write_log(msg):
    msg = '[%s] %s' % (datetime.datetime.now(), msg)
    with open(log_file_name, 'a') as log:
        log.write(msg)
    log.close()


if __name__ == "__main__":
    log_file_name='/home/LogFiles/node_%s_out.log' % os.environ['WEBSITE_ROLE_INSTANCE_ID']

    write_log('Container started')

    if os.system('service ssh start') == 0:
        write_log('ssh daemon started')
    else:
        write_log('issues starting ssh daemon') 
    
    if os.system('service cron start') == 0:
        write_log('cron daemon started')
    else:
        write_log('issues starting cron daemon')

    if not os.path.isdir('/home/wiki'):
        write_log('Creating wiki directory')
        os.mkdir('/home/wiki')
        os.system('git init /home/wiki')
    else:
        write_log('Wiki directory already exists')

    write_log('Dumping environment')
    for var in os.environ:
        write_log('%s==%s' % (var, os.environ[var]))

# here we have a way to customize Gollum without the need to rebuild the image or to manually modify it once deployed
# in the future we will need to add more variables to accomodate more customizations all of these needs to be documented
    if os.environ['GOLLUMCONF']:
        write_log('Config file specified, downloading')
        if not os.path.isdir('/home/conf'):
            os.mkdir('/home/conf')
        os.system('az storage blob download-batch --source %s --destination /home/conf/config.rb --account-key %s' % (os.environ['GOLLUMCONF'], os.environ['GOLLUMCONF_KEY']))
        os.system('/gollum/bin/gollum --config /home/conf/config.rb /home/wiki')
    else:
        os.system('/gollum/bin/gollum --port %s /home/wiki' % os.environ['PORT'])

else:
    print("SHould not get here")

