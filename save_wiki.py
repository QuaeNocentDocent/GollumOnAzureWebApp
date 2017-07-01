#!/usr/bin/env python3
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

log_file_name='/home/LogFiles/node_%s_out.log' % os.environ['WEBSITE_ROLE_INSTANCE_ID']
if os.environ['AZURE_STORAGE_URL']:
    write_log('Saving wiki on %s' % os.environ['AZURE_STORAGE_URL'])
    os.system('az storage blob upload-batch --destination %s --source /home/wiki --account-key %s' % (os.environ['AZURE_STORAGE_URL'], os.environ['AZURE_STORAGE_KEY']))
else:
    write_log('Azure storage not specified skipping backup')

#TODO error checking