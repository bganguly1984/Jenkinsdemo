#!/bin/bash -e

usage() { echo "Usage: $0 [-d <directory where all the artifacts has been downloaded>] [-b 

<directectory path where sfdx cli is installed till bin>]" 1>&2; exit 1; }

while getopts ":d:b:" o; do
    case "${o}" in
        d)
            d=${OPTARG}
            ;;
         b)
            b=${OPTARG}
            ;;
         
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

#echo "d = ${d}"
#echo "b = ${b}"

if [ -z "${d}" ] || [ -z "${b}" ] ; then
    usage
fi

cd "${b}"
sfdx force:auth:sfdxurl:store -f "${d}"/source_url.txt -a sourceorg
sfdx force:auth:sfdxurl:store -f "${d}"/target_url.txt -a targetorg
sfdx force:mdapi:retrieve -r "${d}" -k "${d}"/manifest/package.xml -u sourceorg
unzip "${d}"/unpackaged.zip
sfdx force:mdapi:deploy -d "${d}"/unpackaged -u targetorg -l RunLocalTests -w 20
