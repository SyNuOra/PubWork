create index syapex.ggops_deployments_i1 on
    syapex.ggops_deployments (
        host_id
    );


-- sqlcl_snapshot {"hash":"02ac41fed342e3f19abb0213d44921bc2b1d98ef","type":"INDEX","name":"GGOPS_DEPLOYMENTS_I1","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_DEPLOYMENTS_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_DEPLOYMENTS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>HOST_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}