create index syapex.ggops_paths_i3 on
    syapex.ggops_paths (
        target
    );


-- sqlcl_snapshot {"hash":"a8c780f5a4a2727ba7f8476bbe1f931977a6d593","type":"INDEX","name":"GGOPS_PATHS_I3","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_PATHS_I3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_PATHS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>TARGET</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}