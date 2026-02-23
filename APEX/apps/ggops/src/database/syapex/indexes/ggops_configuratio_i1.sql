create index syapex.ggops_configuratio_i1 on
    syapex.ggops_configuration_files (
        process_id
    );


-- sqlcl_snapshot {"hash":"7851d0d761a1548351ee3837de45613bd549522e","type":"INDEX","name":"GGOPS_CONFIGURATIO_I1","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_CONFIGURATIO_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_CONFIGURATION_FILES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PROCESS_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}