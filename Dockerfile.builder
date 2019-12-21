FROM rosalab/rosa2016.1

RUN rm -rfv /var/lib/rpm \
 && urpmi.removemedia -a \
 && urpmi.addmedia main_release http://abf-downloads.rosalinux.ru/rosa2016.1/repository/x86_64/main/release/ \
 && urpmi.addmedia main_updates http://abf-downloads.rosalinux.ru/rosa2016.1/repository/x86_64/main/updates \
 && urpmi.addmedia main_testing http://abf-downloads.rosalinux.ru/rosa2016.1/repository/x86_64/main/testing \
 && urpmi.addmedia corp_test_personal http://abf-downloads.rosalinux.ru/corp_test_personal/repository/rosa2016.1/x86_64/main/release
 && urpmi --auto --auto-update --no-verify-rpm \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && urpmi --no-suggests --no-verify-rpm --auto mock-urpm git curl sudo builder-c xz timezone \
 && sed -i 's!openmandriva.org!rosalinux.ru!g' /etc/builder-c/filestore_upload.sh \
 && sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
 && groupadd mock \
 && echo "%mock ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && adduser omv \
 && usermod -a -G mock omv \
 && chown -R omv:mock /etc/mock-urpm \
 && rm -rf /var/cache/urpmi/rpms/* \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc

COPY builder.conf /etc/builder-c/
ENTRYPOINT ["/usr/bin/builder"]
#ENTRYPOINT ["/usr/bin/valgrind", "--undef-value-errors=no", "/usr/bin/builder"]
