function  GENERATEBATCHTABLE(app,d)

DS = datastore(app.Output_Path,'IncludeSubfolders',true,'FileExtensions',{'.csv'},'Type','image') ;
Tidx = 0 ;
for j = 1:numel(DS.Files)
    if contains(DS.Files{j},'_Fibers_profile.csv')
        Tidx= Tidx+1 ;
        FLIST{Tidx} = DS.Files{j} ;
    end
end

GTABLE = [] ;
for j = 1:numel(FLIST)
    
    value = FLIST{j};
    [Tablefold,Tablename,~] = fileparts(value);
    
    Tablename = strrep(Tablename,'_Fibers_profile',app.FileFormat)
    
      if ~isempty(d)
    d.Message = {['Table ID: ' num2str(j)  ' / ' num2str(numel(FLIST)) '.' ];...
        [strrep(Dir_Extract(value,Dir_Num(value)),app.FileFormat,'')]};
    d.Value = j/numel(FLIST) ;
      end
      
    TableFolderName = Dir_Extract(value,Dir_Num(value)-2) ;
    
    if strcmp(Dir_Extract(app.Output_Path,Dir_Num(app.Output_Path)),TableFolderName)
        TableFolderName = 'root' ;
        
    end
    if isempty(value)
        continue
    end
    
    TFP =     readtable(FLIST{j}) ;
    TFNAME = [] ;  TFoldNAME = [] ; GTable = [] ;
    TFNAME = table(string(Tablename),'VariableNames',{'File_Name'})   ;
    TFoldNAME = table(string(TableFolderName),'VariableNames',{'Folder_Name'})   ;
    for i = 2:size(TFP,1)
        TFoldNAME(i,1) = table("") ;
        TFNAME(i,1) = table("") ;
    end
    
    GTable = cat(2,TFoldNAME,TFNAME,TFP) ;
    GTABLE = cat(1,GTABLE,GTable) ;
    
    
end

writetable(GTABLE,[app.Output_Path filesep Dir_Extract(app.Output_Path,Dir_Num(app.Output_Path)) '_Batch.csv']) ;

