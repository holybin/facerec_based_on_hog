function [out] = RFClass(param,D1,D2,D3,D4,D5,D6)
%!
%! Description:
%!
%!   RFClass implements Breiman's random forest algorithm for classification. 
%!   It can also be used in unsupervised mode for locating outliers or 
%!   assessing proximities among data points. 
%!   (based on Breiman and Cutler's original Fortran code version 3.3)  
%! 
%! Usage:
%!
%!   param = [ntree,   mtry,    nclass,  iaddcl,  ndsize, ...
%!            imp,     iprox,   ioutlr,  iscale,  ipc, ...
%!            inorm,   isavef,  mdimsc,  mdimpc,  seed ];
%!   out = RFClass(param, x, y, cat, classwt);
%!   out = RFClass(param, x, y, cat, classwt, xts, yts);
%!   out = RFClass(param, xts, yts, forest);
%!   PrintRF(out);
%!
%! Arguments:
%!
%!   param    A row-vector for the 15 parameters described below.
%!   ntree    Number of trees to grow. This should not be set to too small a number, 
%!            to ensure that every input row gets predicted at least a few times. 
%!   mtry     Number of variables randomly sampled as candidates at each split. 
%!   nclass   Number of class in training set.
%!   iaddcl   Should add a synthetic class to the data? 
%!            =0 do not add;  
%!            =1 label the input data as class 1 and add a synthetic class by randomly 
%!            sampling from the product of empirical marginal distributions of the input; 
%!            =2 is similar to =1, but the synthetic data are sampled from the uniform 
%!            hyperrectangle that contain the input.
%!   ndsize   Minimum size of terminal nodes. Setting this number larger causes smaller 
%!            trees to be grown (and thus take less time). 
%!   imp      Should importance of predictors be assessed? (>0 for Yes)
%!   iprox    Should proximity measure among the rows be calculated? (>0 for Yes)
%!   ioutlr   Should outlyingness of rows be assessed?
%!   iscale   Should compute scaling coordinates based on the proximity matrix.
%!   ipc      Should compute principal coordinates from the covariance matrix of the x's.
%!   inorm    Should normalize all variables before computing the principal components.
%!   isavef   If set to 0, the forest will not be retained in the output object; 
%!            set to 1 to retain forest in the output object;
%!            set to 2 to save forest to the file 'rforest.txt' (old file will be overwritten).
%!   mdimsc   Number of scaling coordinates to be extracted. Usually 4-5 is sufficient.
%!   mdimpc   Number of principal components to extract. Must < m-dim.
%!   seed     Seed for random number generation.
%!
%!   x        A m by n data matrix of m samples and n variables containing predictors 
%!            for the training set. 
%!   y        A response column-vector for the training set. 
%!   cat      The vector for variable type. (=1 for continuious; =0 for categorical) 
%!   classwt  Priors of the classes. Need not add up to one.
%!   xts      A p by n data matrix (like x) containing predictors for the test set. 
%!   yts      A response column-vector for the test set. 
%!   forest   A returned object for the Forest.
%!   
%! Output Values:
%!
%!   type     Object tag.
%!   cat      Used categorical vector.
%!   param    Used parameter vector.
%!   mtab     The confusion matrix for training set.
%!   mtabts   The confusion matrix for test set.
%!   errtr    Error rate for training set.
%!   errts    Error rate for test set.
%!   ypredtr  The predicted values of the input training set based on out-of-bag samples.
%!   ypredts  The predicted values of the input test set based on out-of-bag samples.
%!   imp      Vector of variable importance.
%!   predimp  The matrix of predict importance.
%!   classwt  The priors of the classes.
%!   ndbtrees The vector stored the length of each tree. 
%!   trees    The forest in matrix containing  
%!

%
% Last update on Feb. 25, 2003
% By Ting Wang   Merck & Co.
%
  LF=char(10);
  select = 0;
  
 errmsg1=['==> Incorrect # of input arguments ...',LF];
 errmsg2=['==> Parameter must be 1 x 15 vector ...',LF];
 errmsg3=['==> Missing data in parameter vector is not allowed ...',LF];
 errmsg4=['==> Missing data in Training set matrix is not allowed ...',LF];
 errmsg5=['==> Missing data in Training response vector is not allowed ...',LF];
 errmsg6=['==> Training data matrix and its response vector must have same # of rows ...',LF];
 errmsg7=['==> Test data matrix and its response vector must have same # of rows ...',LF];
 errmsg8=['==> Response must be a 1-column vector  ...',LF];
 errmsg9=['==> Categorical vector and the predictor matrix must have same # of column ...',LF];
errmsg10=['==> Class weight vector must = nclass ...',LF];
errmsg11=['==> Missing data in the categorical vector is not allowed ...',LF];
errmsg12=['==> Missing data in the class weight vector is not allowed ...',LF];
errmsg13=['==> Values in the categorical vector must be integer > 0 ...',LF];
errmsg14=['==> Values in the class weight vector must be > 0 ...',LF];
errmsg15=['==> Parameter mdimpc must be less than the # of columns in predictor matrix ...',LF];
errmsg16=['==> Length of the class weight vector must be nclass ...',LF];
errmsg17=['==> Scaling could not be set if the option proximity is not being set ...',LF];
errmsg18=['==> Training and Test set matrix must have same # of columns ...',LF];
errmsg19=['==> Test data matrix and its response vector must have same # of rows ...',LF];
errmsg20=['==> Test response must be a 1-column vector ...',LF];
errmsg21=['==> Some components were missing in Forest ...',LF];
errmsg22=['==> The ntree mismatch the length of the given Forest ...',LF];
errmsg23=['==> Forest seems to be incorrect ...',LF];
    
  if ~any(nargin==[4 5 7]),          error(errmsg1);  end;    
  if any(size(param)~=[1 15]),       error(errmsg2);  end;    
    if (nargin==5)       select=1;
    elseif (nargin==7)   select=2;
    else                 select=3; 
    end;  
  if any(any(isnan(param))),         error(errmsg3);  end;  
    ntree    = param(1);   
    mtry     = param(2);       
    nclass   = param(3);
    iaddcl   = param(4);    
    ndsize   = param(5);   
    imp      = param(6); 
    iprox    = param(7);  
    ioutlr   = param(8);  
    iscale   = param(9);   
    ipc      = param(10);   
    inorm    = param(11);   
    isavef   = param(12);        
    mdimsc   = param(13); 
    mdimpc   = param(14);    
    seed     = param(15);
  if any(any(isnan(D1))),            error(errmsg4);  end; 
  if any(any(isnan(D2))),            error(errmsg5);  end; 
  if size(D1,1)~=size(D2,1)
     if (select<3),                  error(errmsg6);  
     else,                           error(errmsg7);  
     end;
  end;
  if size(D2,2)~=1,                  error(errmsg8);  end;
      if select<3
  if ~any(size(D3)==[1 size(D1,2)]), error(errmsg9);  end;
  if ~any(size(D4)==[1 nclass]),     error(errmsg10); end;   
      end;
  if (select==3)
    fdstr = reshape(char(fieldnames(D3))',1,[]);
    if length([strfind(fdstr,'cat'),strfind(fdstr,'classwt'), ...
               strfind(fdstr,'ndbtrees'),strfind(fdstr,'trees')])<4
        error(errmsg21);     
    end
    cat      = D3.cat;
    classwt  = D3.classwt;
    ndbtrees = D3.ndbtrees;
    trees    = D3.trees;
    if length(ndbtrees)~=ntree,      error(errmsg22); end;
  else
    cat      = int32(D3); 
    classwt  = single(D4);    
  end
  if any(any(isnan(double(cat)))),    error(errmsg11);  end; 
  if any(any(isnan(double(classwt)))),error(errmsg12);  end; 
  if (min(cat)<=0),                   error(errmsg13);  end;
  if (any(classwt<=0)),               error(errmsg14);  end;
  if (mdimpc>size(D1,2)),             error(errmsg15);  end;
  if (length(classwt)~=nclass),       error(errmsg16);  end;
  if (iscale==1 & iprox==0),          error(errmsg17);  end;  
  if (isavef==2)
      fn = dir('cforest.txt');
      if length(fn)>0,    dos('del cforest.txt'); end;
  end;    
  
% Run train set 
if select==1
      lablts   = 0;       
      mdim     = size(D1,2);
      nsample0 = size(D1,1);
      ntest    = 1;                          
      irunf    = 0;             
      ntrees   = 1;                     
    if (iaddcl>0), D1=[D1;D1]; D2=[D2;D2]; end;
    x     = single(D1');
    y     =  int32(D2');
    xts   = single(zeros(mdim,1));   
    yts   =  int32(zeros(1,1));     
    pid   = single(zeros(1,nclass)); 
    trees = single(zeros(6,ntrees)); 
    ndbtrees = int32(zeros(1,ntree));  
    
% Run training set with test set 
elseif select==2
      lablts   = (length(unique(D6))>1);    
      mdim     = size(D1,2);
      nsample0 = size(D1,1);
      ntest    = size(D5,1);
      irunf    = 0;   
      ntrees   = 1;    
  if size(D5,2)~=size(D1,2),                 error(errmsg18);  end;   
  if size(D5,1)~=size(D6,1),                 error(errmsg19);  end;   
  if size(D6,2)~=1,                          error(errmsg20);  end;   
  if iaddcl>0, D1=[D1;D1]; D2=[D2;D2]; end;      
    x     = single(D1');
    y     =  int32(D2');
    xts   = single(D5');  
    yts   =  int32(D6');      
    pid   = single(zeros(1,nclass));
    ndbtrees = int32(zeros(1,ntree));    
    trees = single(zeros(6,ntrees));

% Run test data with forest 
elseif select==3
      lablts   = (length(unique(D2))>1);       
      mdim     = size(D1,2);
      nsample0 = double(max(ndbtrees));
      ntest    = size(D1,1); 
      irunf    = 1;       
      ntrees   = sum(ndbtrees);  
  if any(size(trees)~=[ntrees 6]),           error(errmsg23);    end;  
    x     = single(zeros(mdim,nsample0));  
    y     = int32(zeros(1,nsample0));        
    xts   = single(D1');  
    yts   = int32(D2');      
    pid   = single(classwt');
    ndbtrees = int32(ndbtrees');        
    trees = single(trees');
end
  
% Prepare parameters 
    nsample = (iaddcl+1) * nsample0;
    nrnodes = 2*(nsample/ndsize) + 1;
    mopt    = ipc*(mdim-1) + 1;
    mimp    = imp*(mdim-1) + 1;
    nimp    = imp*(nsample-1) + 1;
    near    = iprox*(nsample0-1) + 1;
    mred    = ipc*mdimpc + (1-ipc)*mdim;
    look    = 1;    % Always =1; No standard output on screen 
    ipi     = 1;    % Always =1; Use vector classwt
    maxcat = max(cat);  
    
  parameter = int32( ...
     [mdim;    nsample0; nclass;    maxcat;    ntest; ...
      lablts;  iaddcl;   ntree;     mtry;      look; ...
      ipi;     ndsize;   imp;       iprox;     ioutlr;...
      iscale;  mdimsc;   ipc;       mdimpc;    inorm; ...
      irunf;   seed;     isavef;    ntrees;    nsample; ...
      nrnodes; mopt;     mimp;      nimp;      near; ...
      mred] );
    
  tic; 
       [ jest,   jet,    counttr, countts, ...
         errtrA, errtsA, mtab,    mtabts, ...
         nodestatusA,  bestvarA,  treemapA, ...
         nodeclassA,   xbestsplitA, prox, ...
         outlier, errimp, diffmarg, cntmarg, ...
         tgini, prox2 ] = ...
  RFClassification(parameter,x,y,cat,classwt,xts,yts,pid,trees,ndbtrees);
  toc;

% Return Output 
  disp(['! Collecting outputs. Please wait ...',LF]);
      out = [];
      out.type     = 'Classification';
      out.cat      = cat;
      out.param    = double(param);
  if select==1 
      out.mtab     = double(mtab);
      out.ypredtr  = jest';
      out.counttr  = counttr'; 
      out.errtr    = double(errtrA');     
  elseif select==2
      out.mtab     = double(mtab);
      out.mtabts   = double(mtabts);
      out.ypredtr  = jest';
      out.ypredts  = jet';
      out.counttr  = counttr'; 
      out.countts  = countts';
      out.errtr    = double(errtrA');     
      out.errts    = double(errtsA');
  elseif select==3
      out.mtabts   = double(mtabts);
      out.ypredts  = jet';
      out.errts    = double(errtsA');
  end
  if (imp==1)
      out.errimp   = double(errimp);
      out.diffmarg = double(diffmarg);
      out.cntmarg  = double(cntmarg);
      out.tgini    = double(tgini);
  end
  if (iprox==1)
      out.prox     = double(prox);  
      out.prox2    = double(prox2); 
  end
  if (ioutlr==1)
      out.outlier  = double(outlier); 
  end
  if (isavef==1)
      forest=[]; L=size(nodestatusA,2); 
      for i=1:ntree;
        tree=[ nodestatusA(i,:)', ...
               bestvarA(i,:)', ...
       reshape(treemapA(i,1,:),L,1), ...
       reshape(treemapA(i,2,:),L,1), ...
               nodeclassA(i,:)', ...
               xbestsplitA(i,:)' ];
        tree=tree(1:double(ndbtrees(i)),:);
        forest=[forest;tree];
      end
      out.classwt  = double(pid);
      out.ndbtrees = double(ndbtrees');
      out.trees    = double(forest);
  end
  if (isavef==2)
      out.filename = 'cforest.txt';
  end    
  
