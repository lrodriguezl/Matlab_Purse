function [files_list, Folder_List]= Folder_Reader(start_path,name_pattern)
% reading multiple folders
%%
Folder_Char=ls([start_path, name_pattern,'*']);
[Folder_List] = char2array(Folder_Char);
folder_idx = find(strncmp('/',Folder_List,1));

files_list = {};
%%
for i=1:length(folder_idx)
    F=Folder_List{folder_idx(i)};
    % replace colon with back slash
    folder_path = strrep(F,':','/');
    % read files in current folder
    files_in_folder = ls(folder_path);
    % convert to array
    files = char2array(files_in_folder);
    % append to master list
    for j=1:length(files)
        if ~strcmp(files{j},'')
            path = [folder_path, files{j}];
            files_list = vertcat(files_list,path);
        end
    end
end

end