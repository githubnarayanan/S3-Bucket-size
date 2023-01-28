#!/usr/bin/bash
set +x
PROFILE=default
function calcs3bucketsize() {
    sizeInBytes=aws --profile ${PROFILE} s3 ls s3://"${1}" --recursive --human-readable --summarize | awk END'{print}'
    echo ${1},${sizeInBytes} >> buckets-sizes.csv
    printf "DONE. Size of the bucket ${1}. %s\n " "${sizeInBytes}"
}
[ -f buckets-sizes.csv ] && rm -fr buckets-sizes.csv
buckets=aws --profile ${PROFILE}  s3 ls | awk '{print $3}'
i=1
for j in ${buckets}; do
    printf "calculating the size of the bucket[%s]=%s. \n " "${i}" "${j}"
    i=$((i+1))
    # to expedite the calculation, make the cli commands run parallel in the background
    calcs3bucketsize ${j} &
done
