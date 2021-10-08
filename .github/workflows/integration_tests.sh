#!/bin/bash

set -eu
set -x

cd /src


echo -e "[metwork_${DEP_BRANCH}]" >/etc/yum.repos.d/metwork.repo
echo -e "name=Metwork Continuous Integration Branch ${DEP_BRANCH}" >> /etc/yum.repos.d/metwork.repo
echo -e "baseurl=http://metwork-framework.org/pub/metwork/continuous_integration/rpms/${DEP_BRANCH}/centos6/" >> /etc/yum.repos.d/metwork.repo
echo -e "gpgcheck=0\n\enabled=1\n\metadata_expire=0\n" >>/etc/yum.repos.d/metwork.repo


    yum -y install metwork-mfserv-full metwork-mfext-layer-python2
    yum -y install git make
    git init python2_tests
    cd python2_tests
    git remote add -t ${DEP_BRANCH} -f origin https://github.com/metwork-framework/mfserv.git
    git config core.sparseCheckout true
    echo "integration_tests/" > .git/info/sparse-checkout
    git pull origin ${DEP_BRANCH}
    su --command="mfserv.init" - mfserv
    su --command="mfserv.start" - mfserv
    su --command="mfserv.status" - mfserv
    if test -d "integration_tests"; then chown -R mfserv integration_tests; cd integration_tests; su --command="cd `pwd`; ./run_integration_tests.sh" - mfserv; cd ..; fi
    su --command="mfserv.stop" - mfserv


