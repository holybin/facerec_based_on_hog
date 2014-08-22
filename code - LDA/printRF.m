function printRF(out)
%!
%! Description:
%!
%!   Print summary for output object returned from RFReg and RFClass.
%! 
%! Usage:
%!
%!   out = RFReg(param, x, y);
%!   PrintRF(out);
%!
%! Arguments:
%!
%!   out      An output object returned from RFReg or RFClass.
%!

%
% Last update on Jun. 27, 2003
% By Ting Wang   Merck & Co.
%
  nm = fieldnames(out);
  for i=1:length(nm)    % Print parameter settings
    if strcmp(nm(i),'param')
       disp(' ');
       disp(['  Number of Trees: ',num2str(out.param(1))]);
       disp(['  No. of Variables tried at each split: ', ...
               num2str(out.param(2))]);
    end;
  end;
  for i=1:length(nm)    % Print error rate for training/test set
    if strcmp(nm(i),'errtr')
       disp(['  OOB estimate error rate for training data: ', ...
          sprintf('%6.4f',out.errtr(end)),'%']);      
    end;
    if strcmp(nm(i),'errts')
       disp(['  OOB estimate error rate for test data: ', ...
          sprintf('%6.4f',out.errts(end)),'%']);      
    end;
  end;
  for i=1:length(nm)    % Print confusion matrix for training/test set
    if strcmp(nm(i),'mtab')
       disp(' ');
       disp(['        Confusion Matrix For Training Set']);
       k=size(out.mtab,1);
       disp(['       |',sprintf('%6.0f',(1:k)),' |   err %',]);
       disp(['  -----|',repmat(['-'],1,6*k),   '-|---------']);
       for j=1:k
          s=sum(out.mtab(j,:));
          if s>0, err=100*(1-out.mtab(j,j)/s);
          else,   err=NaN; end;
       disp([sprintf('%6.0f',j),' |', ...
            sprintf('%6.0f',out.mtab(j,:)), ' |', ...
            sprintf('%9.4f',err)]);
       end;
    end;
    if strcmp(nm(i),'mtabts')
       disp(' ');      
       disp(['        Confusion Matrix For Test Set']);
       k=size(out.mtabts,1);
       disp(['       |',sprintf('%6.0f',(1:k)),' |   err %',]);
       disp(['  -----|',repmat(['-'],1,6*k),   '-|---------']);
       for i=1:k
          s=sum(out.mtabts(i,:));
          if s>0, err=100*(1-out.mtabts(i,i)/s);
          else,   err=NaN; end;
       disp([sprintf('%6.0f',i),' |', ...
            sprintf('%6.0f',out.mtabts(i,:)), ' |', ...
            sprintf('%9.4f',err)]);
       end;
    end;
  end;
  disp(' ');
