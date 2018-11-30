KB_PORT=9090
KB_BIN=/home/bbkruit/scratch/trident/build/trident
KB_PATH=/home/jurbani/data/motherkb-trident

prun -o .kb_log -v -np 1 $KB_BIN server -i $KB_PATH --port $KB_PORT </dev/null 2> .kb_node &
echo "waiting 5 seconds for trident to set up..."
sleep 5
KB_NODE=$(cat .kb_node | grep '^:' | grep -oP '(node...)')
KB_PID=$!
echo "trident should be running now on node $KB_NODE:$KB_PORT (connected to process $KB_PID)"

source venv/bin/activate
python3 sparql.py $KB_NODE:$KB_PORT "select * where {<http://rdf.freebase.com/ns/m.01cx6d_> ?p ?o} limit 100"
deactivate

kill $KB_PID
