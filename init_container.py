#!/usr/bin/env python
import os
import datetime

def write_log(msg):
    msg = '[%s] %s\n' % (datetime.datetime.now(), msg)
    if os.path.exists(log_file_name):
        append_write = 'a'
    else:
        append_write = 'w'
    with open(log_file_name, append_write) as log:
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
# assumptions and decisions
# I always use download-batch regardeless the number of the files
# Customization files to be put in the wiki repo are positioned in a subfolder of the container 
# config.rb is positioned in the root of the container

    if os.environ['GOLLUMCUSTOM']:
        write_log('Checking for custom css and js file, downloading')
        #no error checking for this release
        os.mkdir('/home/temp')
        os.system('az storage blob download-batch --source %s --destination /home/temp --account-key %s --pattern %s/*' % (os.environ['GOLLUMCONF'], os.environ['GOLLUMCONF_KEY'], os.environ['GOLLUMCUSTOM']))
        os.system('cp /home/temp/%s /home/wiki' % os.environ['GOLLUMCUSTOM'])
        os.rmdir('/home/temp')
        os.chdir('/home/wiki')
        os.system('git add /home/wiki/*')
        os.system('git commit /home/wiki/* -m ''gollum customized''')
        #let's add omnigollum here at the moment, tI dont' know if it is worth to move it into the conatiner itself
        write_log('About to install omnigollum')
        
        

    if os.environ['GOLLUMCONF']:
        write_log('Config file specified, downloading')
        if not os.path.isdir('/home/conf'):
            os.mkdir('/home/conf')
        os.system('az storage blob download-batch --source %s --destination /home/conf --account-key %s --pattern config.rb' % (os.environ['GOLLUMCONF'], os.environ['GOLLUMCONF_KEY']))
        write_log('Ready to start gollum')
        os.system('/gollum/bin/gollum --config /home/conf/config.rb --port %s' % os.environ['PORT'])
    else:
        os.system('/gollum/bin/gollum --port %s /home/wiki' % os.environ['PORT'])



else:
    print("SHould not get here")

