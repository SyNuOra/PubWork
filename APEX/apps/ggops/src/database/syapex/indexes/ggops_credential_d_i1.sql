create index syapex.ggops_credential_d_i1 on
    syapex.ggops_credential_domains (
        deployment_id
    );


-- sqlcl_snapshot {"hash":"8b7685e4ffdb99b4dc51d0e1ed1b08d7a6a123b0","type":"INDEX","name":"GGOPS_CREDENTIAL_D_I1","schemaName":"SYAPEX","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>SYAPEX</SCHEMA>\n   <NAME>GGOPS_CREDENTIAL_D_I1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>SYAPEX</SCHEMA>\n         <NAME>GGOPS_CREDENTIAL_DOMAINS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DEPLOYMENT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}