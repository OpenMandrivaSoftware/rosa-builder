#!/bin/bash
echo 'RosaLAB platform config generator'

extra_cfg_options="$EXTRA_CFG_OPTIONS"
extra_cfg_urpm_options="$EXTRA_CFG_URPM_OPTIONS"
uname="$UNAME"
email="$EMAIL"
platform_arch="$PLATFORM_ARCH"
platform_name=${PLATFORM_NAME:-"rosa2016.1"}
repo_url="$REPO_URL"
repo_names="$REPO_NAMES"

default_cfg=/etc/mock-urpm/default.cfg
gen_included_repos() {

names_arr=($repo_names)
urls_arr=($repo_url)

for (( i=0; i<${#names_arr[@]}; i++ ));
do
	echo '"'${names_arr[i]}'"': '"'${urls_arr[i]}'"', >> $default_cfg
done
# close urpmi repos section
echo '}' >> $default_cfg
}

cat <<EOF> $default_cfg
config_opts['target_arch'] = '$platform_arch --without uclibc'
config_opts['legal_host_arches'] = ('i586', 'i686', 'x86_64')
config_opts['urpmi_options'] = '--no-suggests --no-verify-rpm --ignoresize --downloader wget --fastunsafe --nolock $extra_cfg_options'
config_opts['urpm_options'] = '$extra_cfg_urpm_options'
config_opts['root'] = '$platform_name-$platform_arch'
config_opts['chroot_setup'] = 'basesystem-minimal basesystem-build xz timezone'
#config_opts['urpm_options'] = '--xml-info=never $extra_cfg_urpm_options'
config_opts['plugin_conf']['root_cache_enable'] = True
config_opts['plugin_conf']['root_cache_opts']['age_check'] = True
config_opts['plugin_conf']['root_cache_opts']['max_age_days'] = 1
config_opts['plugin_conf']['ccache_enable'] = False

config_opts['plugin_conf']['tmpfs_enable'] = False
config_opts['plugin_conf']['tmpfs_opts'] = {}
config_opts['plugin_conf']['tmpfs_opts']['required_ram_mb'] = 64000
config_opts['plugin_conf']['tmpfs_opts']['max_fs_size'] = '50g'

config_opts['use_system_media'] = False
config_opts['basedir'] = '/var/lib/mock-urpm/'
config_opts['cache_topdir'] = '/var/cache/mock-urpm/'
config_opts['dist'] = '${platform_name}'  # only useful for --resultdir variable subst
config_opts['macros']['%packager'] = '$uname <$email>'
config_opts["urpmi_media"] = {
EOF

gen_included_repos
