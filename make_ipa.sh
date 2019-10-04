if [ $# -eq 0 ]
  then
    echo "need version number"
    exit 0
fi

mkdir Payload
cp -r "./build/ios/iphoneos/Runner.app" Payload
zip -r metlink.zip Payload
mv metlink.zip metlink-$1.ipa
rm -rf Payload 
