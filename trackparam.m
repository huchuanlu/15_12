%%******Change 'title' to choose the sequence you wish to run******%%
switch (title) 
    %
    case 'Occlusion1'; 
        p = [177,147,115,145,0];
        opt = struct('affsig',[4, 4,.005,.00,.00,.000]);         
    %
    case 'Occlusion2';    
        p = [156,107,74,100,0.00];
        opt = struct('affsig',[4, 4,.005,.015,.000,.000]);                             
    %
    case 'Caviar1'; 
        p = [145,112,30,79,0];
        opt = struct('affsig',[4, 4,.005,.000,.000,.000]);
    %  
    case 'Caviar2';   
        p = [ 152, 68, 18, 61, 0.00 ];
        opt = struct('affsig',[4, 4,.005,.000,.000,.000]); 
    %
    case 'Car4'; 
        p = [245 180 200 150 0];
        opt = struct('affsig',[4, 4,.02,.00,.000,.000]); 
    %
    case 'Singer1';  
        p = [100, 200, 100, 300, 0];
        opt = struct('affsig',[4, 4,.01,.00,.00,.000]);    
    %
    case 'Car11';  
        p = [89 140 30 25 0];
        opt = struct('affsig',[2, 2,.005,.00,.00,.00]);      
    %
    case 'Stone'; 
        p = [115 150 43 20 0.0];
        opt = struct('affsig',[4, 4,.005,.000,.000,.0000]); 
    %
    case 'Girl'; 
        p = [180,109,104,127,0];
        opt = struct('affsig',[10,10,.02,.00,.000,.000]);
    %
    case 'Deer';  
        p = [350, 40, 100, 70, 0];
        opt = struct('affsig',[15,15,.005,.000,.000,.000]); 
    %
    case 'Owl';      
        p = [380 247 56 100 0];
        opt = struct('affsig',[25,25,.01,.00,.00,.00]); 
    %
    case 'Dudek';  
        p = [188,192,110,130,-0.08];
        opt = struct('affsig',[9,9,.02,.02,.001,.000]); 
    %
    case 'Sylvester';  
        p = [328,168,80,88,0];
        opt = struct('affsig',[10,10,.02,.02,.00,.00]); 
    %
    case 'Crossing';
        p=[205+8.5,151+25,17,50,0];
       opt = struct('affsig',[4,4,.005,.00,.00,.00]);
    % 
    %
    case 'DavidIndoorNew'; 
        p = [194,108,46,60,0.00];
        opt = struct('affsig',[4, 4,.002,.01,.00,.00]);
    %
    case 'Singer2';
       p=[298+33.5,149+61,67,122,0];    
       opt = struct('affsig',[4,4,.005,.00,.00,.00]);
    %
     case 'Leno';       
        p = [328, 121, 112,146, 0];
        opt = struct('affsig',[10,10,.01,.005,.00,.00]);  
    otherwise;  error(['unknown title ' title]);
end
%%******Change 'title' to choose the sequence you wish to run******%%

%%***************************Data Path*****************************%%
dataPath = [ 'Data\' title '\'];
%%***************************Data Path*****************************%%