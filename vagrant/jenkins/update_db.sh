scp cmoreton@dzsalt.netsensia.com:~/db_create.zip .
mv db_create.zip /Users/chris/Dropbox/public/VM
#shasum -a 256 /Users/chris/Dropbox/public/VM/db_create.zip | sed "s/\/Users\/chris\/Dropbox\/public\/VM\/db_create.zip//" > ../../salt/files/directorzone/db_sha
shasum -a 256 /Users/chris/Dropbox/public/VM/db_create.zip > ../../salt/files/directorzone/db_sha
