#!/bin/sh

set -x
host='freebsd12'
virsh qemu-agent-command $host  '{"execute":"guest-get-osinfo"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-get-timezone"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-get-users"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-get-host-name"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-network-get-interfaces"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-info"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-ping"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-get-time"}' | jq .
virsh qemu-agent-command $host  '{"execute":"guest-get-fsinfo"}' | jq .
