alter table syapex.ggops_paths
    add constraint ggops_paths_process_id_fk
        foreign key ( process_id )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"6772a20c27d3c0dd4f1a928256a85db4ccf6faa9","type":"REF_CONSTRAINT","name":"GGOPS_PATHS_PROCESS_ID_FK","schemaName":"SYAPEX","sxml":""}