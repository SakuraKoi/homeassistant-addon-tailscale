#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Home Assistant Community Add-on: Tailscale
# S6 Overlay stage2 hook to customize services
# ==============================================================================

# Disable dnsmasq service when userspace-networking is enabled or accepting dns is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_dns";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/dnsmasq
    rm /etc/s6-overlay/s6-rc.d/tailscaled/dependencies.d/dnsmasq
fi

# Disable protect-subnets service when userspace-networking is enabled or accepting routes is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "accept_routes";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/protect-subnets
    rm /etc/s6-overlay/s6-rc.d/post-tailscaled/dependencies.d/protect-subnets
fi

# Disable forwarding service when userspace-networking is enabled or forwarding to host is disabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking" || \
    bashio::config.false "forward_to_host";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/forwarding
fi

# Disable mss-clamping service when userspace-networking is enabled
if ! bashio::config.has_value "userspace_networking" || \
    bashio::config.true "userspace_networking";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/mss-clamping
fi

# Disable taildrop service when it has been explicitly disabled
if bashio::config.false 'taildrop'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/taildrop
fi

# Disable serve service when proxy and/or funnel has not been explicitly enabled
if ! bashio::config.true 'proxy'; then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/serve
    rm /etc/s6-overlay/s6-rc.d/certificate/dependencies.d/serve
fi

# Disable certificate service when it has not been configured
if ! bashio::config.has_value "lets_encrypt_certfile" || \
    ! bashio::config.has_value "lets_encrypt_keyfile";
then
    rm /etc/s6-overlay/s6-rc.d/user/contents.d/certificate
fi