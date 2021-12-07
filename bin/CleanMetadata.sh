#!/bin/bash

cut --complement -f 9-14 hisHMECanno.tsv | sed 's/%20/ /g' > hisHMECannoFilt.tsv
cut --complement -f 9-14 hisMCF7anno.tsv | sed 's/%20/ /g' > hisMCF7annoFilt.tsv
cut --complement -f 9-14 hisMDAMB231anno.tsv | sed 's/%20/ /g' > hisMDAMB231annoFilt.tsv

cut --complement -f 9-14 tfHMECanno.tsv | sed 's/%20/ /g' > tfHMECannoFilt.tsv
cut --complement -f 9-14 tfMCF7anno.tsv | sed 's/%20/ /g' > tfMCF7annoFilt.tsv
cut --complement -f 9-14 tfMDAMB231anno.tsv | sed 's/%20/ /g' > tfMDAMB231annoFilt.tsv

