function drawopt = drawtrackresult(drawopt, fno, frame, tmpl, param)

%%��ͼ����
if (isempty(drawopt))       
  figure('position',[0 0 352 288]); clf;                               
  set(gcf,'DoubleBuffer','on','MenuBar','none');
  colormap('gray');
  drawopt.curaxis = [];
  drawopt.curaxis.frm  = axes('position', [0.00 0 1.00 1.0]);
end

%%����ȫͼ
curaxis = drawopt.curaxis;
axes(curaxis.frm);      
imagesc(frame, [0,1]); 
hold on;     

%%����ͼ����ٿ�
sz = size(tmpl.mean); 
% if  fno > 1
%     for num = 1:size(param.paramPos,2)
%         drawbox(sz, param.paramPos(:,num), 'Color','b', 'LineWidth',2);
%     end
%     %
%     for num = 1:size(param.paramNeg,2)
%         drawbox(sz, param.paramNeg(:,num), 'Color','g', 'LineWidth',2);
%     end
% end

% if  fno > 1
%     for num = 1:size(param.top10,2)
%         drawbox(sz, param.top10(:,num), 'Color','m', 'LineWidth',2);
%     end
% end

drawbox(sz, param.est, 'Color','r', 'LineWidth',2);

%%��ʾĿǰ���ٵ��ǵڼ�֡
text(5, 18, num2str(fno), 'Color','r', 'FontWeight','bold', 'FontSize',20);

axis equal tight off;
hold off;
%%������ͼ
drawnow;        

