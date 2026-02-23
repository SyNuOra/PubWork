alter table syapex.ggops_processes
    add constraint ggops_processes_credential_fk
        foreign key ( credential_id )
            references syapex.ggops_credentials ( user_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"991a12242cda57c7472483cea6f1a7d3c284f332","type":"REF_CONSTRAINT","name":"GGOPS_PROCESSES_CREDENTIAL_FK","schemaName":"SYAPEX","sxml":""}