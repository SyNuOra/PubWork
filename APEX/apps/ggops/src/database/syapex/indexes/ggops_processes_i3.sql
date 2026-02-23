create index syapex.ggops_processes_i3 on
    syapex.ggops_processes (
        encryption_profile
    );


-- sqlcl_snapshot {"hash":"0691fbeda3d6be03e725e3dafcfb719e0727cab2","type":"INDEX","name":"GGOPS_PROCESSES_I3","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_PROCESSES_I3</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_PROCESSES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ENCRYPTION_PROFILE</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}