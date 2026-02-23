create index syapex.ggops_paths_i1 on
    syapex.ggops_paths (
        process_id
    );


-- sqlcl_snapshot {"hash":"919c8156b9f19ff1d083bd17243271ecd93da45a","type":"INDEX","name":"GGOPS_PATHS_I1","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_PATHS_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_PATHS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PROCESS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}