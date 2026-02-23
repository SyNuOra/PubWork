alter table syapex.ggops_configuration_files
    add constraint ggops_configuration_files_process_id_fk
        foreign key ( process_id )
            references syapex.ggops_processes ( process_id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"2a5bcd7e1d06cedf81e93c16c58b025c1d9bbfb0","type":"REF_CONSTRAINT","name":"GGOPS_CONFIGURATION_FILES_PROCESS_ID_FK","schemaName":"SYAPEX","sxml":""}