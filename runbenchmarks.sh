#!/bin/bash

repeats=20
output_file='benchmark_results.csv'
command_to_run='echo 1'

run_tests() {
    
    echo 'Benchmarking ' $command_to_run '...';
    echo '======' $command_to_run '======' >> $output_file;

    for (( i = 1; i <= $repeats ; i++ ))
    do
        p=$(( $i * 100 / $repeats))
        l=$(seq -s "+" $i | sed 's/[0-9]//g')

        /usr/bin/time -f "%E,%U,%S" -o ${output_file} -a ${command_to_run} > /dev/null 2>&1

        sync && echo 3 > /proc/sys/vm/drop_caches

        echo -ne ${l}' ('${p}'%) \r'
    done;

    echo -ne '\n'

    echo '--------------------------' >> $output_file
}

while getopts n:c:o: OPT
do
    case "$OPT" in
        n)
            repeats=$OPTARG
            ;;
        o)
            output_file=$OPTARG
            ;;
        c)
            command_to_run=$OPTARG
            run_tests
            ;;
        \?)
            echo 'No arguments supplied'
            exit 1
            ;;
    esac
done

shift `expr $OPTIND - 1`