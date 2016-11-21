#!/usr/bin/awk -f
function shc_cmnd_snag( cmnd_string, base_ary,  cmnd_out_counter ){
    #usage: shc_cmnd_snag(s, a)
    #purpose: capture the standard output of command 's' to array 'a' 
    #         return the number of lines of output
    #notes: I/O redirection is not handled directly buy this function. If you
    #       want to use file descriptors it's up to you include that in your
    #       command
    for ( cmnd_out_counter = 1 ;
            cmnd_string | getline base_ary[cmnd_out_counter] ;
            cmnd_out_counter += 1){
        #empty loop
    }
    close(cmnd_string)
    return cmnd_out_counter -  1
}

function snag_ip(cloud_results,   counter){
    counter = 1
    for (line in cloud_results){
        if (cloud_results[line] ~ /^[[:space:]]*ip_address:/) {
            ips[counter++] = cloud_results[line + 1] 
        }
    }

    for ( ip_key in ips ) {
        ip = ips[ip_key]
        check = sprintf("nc -w 10 -z %s %s", ip, SSH_PORT)
	print check
	if (system(check) == 0 ) {
            print "result: " system(check)
            gsub(/[[:space:]]/,"",ip)
            return ip 
        }
    }
    print "sorry no valid IP (with ssh on) found"
}

function write_roster(ip,   outputfile){
    outputfile = "/usr/local/etc/salt/roster"
    print "web1:" > outputfile
    print "  host: " ip >> outputfile
    print "  user: freebsd" >> outputfile
    print "  sudo: True" >> outputfile
}

BEGIN {
    SSH_PORT = 22
    salt_cloud_command = "salt-cloud -y -P -m /usr/local/etc/salt/cloud.maps.d/reactive.map"
    salt_ssh_command = "salt-ssh -i --priv /usr/local/etc/salt/pki/cloud/do.pem '*' state.highstate"
    shc_cmnd_snag( salt_cloud_command, cloud_results )
    valid_ip = snag_ip(cloud_results)
    write_roster(valid_ip)
    system(salt_ssh_command)
    print "IP:" valid_ip

}
