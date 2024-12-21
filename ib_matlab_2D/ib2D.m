% ib2D.m
% This script is the main program.
clear;
clc;

global dt Nb N h rho mu ip im a;
global kp km K grav m;
initialize
init_a % used for fft applied to fluid

myVideo = VideoWriter('video.mp4', 'MPEG-4');
open(myVideo)
for clock=1:clockmax
  % target points
  %V=V-(1/(2*m))*K*(Z-X)*dt;
  %V(:,2)=V(:,2)-(1/2)*grav*dt;
  %Z=Z+V*dt;
  
  % the water
  X=X+dt*interp(u,X,Nb,h,N); % equation (4)
  %FF=K*(Z-XX); % equation (5)
  %ff=spread(FF,XX,Nb,N,h); % equation (3)
  %[u,uu]=fluid(u,ff,h,ip,im,a,dt,rho,mu); % equation (1), (2)
  %X=X+dt*interp(uu,XX,Nb,h,N); % equation (4)

  % the wall
  XX2=X2+(dt/2)*interp(u,X2,Nb2,h,N); % equation (4)
  FF2=K2*(Z2-XX2); % equation (5)
  ff2=spread(FF2,XX2,Nb2,N,h); % equation (3)
  
  ff2(:,:,2)= ff2(:,:,2) - 100.0; % external body force

  [u,uu]=fluid(u,ff2,h,ip,im,a,dt,rho,mu); % equation (1), (2)
  X2=X2+dt*interp(uu,XX2,Nb2,h,N); % equation (4)

  %animation:
  if mod(clock,100) == 0
      clf;
      quiver(xgrid,ygrid,u(:,:,1),u(:,:,2))

      hold on
      plot(X2(:,1),X2(:,2),'.r')
      plot(X(:,1),X(:,2),'.b','MarkerSize',20)
      %plot(Z(:,1),Z(:,2),'.g')
      axis equal
      axis manual
      title('particle in multiple solution maze')

      frame = getframe(gcf);  % Get the current figure frame
      writeVideo(myVideo, frame);  % Write the frame to the video

      hold off
  end
end
close(myVideo)



%% streamline attempts...
uodd = u(1:2:end,:,:);
uodd = uodd(:,1:2:end,:);
xgridodd = xgrid(1:2:end,:);
xgridodd = xgridodd(:,1:2:end);
ygridodd = ygrid(1:2:end,:);
ygridodd = ygridodd(:,1:2:end);

xi = zeros(size(uodd,1));
xi(1,1) = uodd(1,1,2);
for k=1:size(uodd,1)-1
    xi(k+1,1) = xi(k,1)/size(uodd,1) + uodd(k,1,2);
end

for k=1:size(uodd,1)-1
    xi(:,k+1) = xi(:,k)/size(uodd,1) + uodd(:,k,1);
end

clf;
hold on
plot(X2(:,1),X2(:,2),'.r')
plot(X(:,1),X(:,2),'.b')
contour(xgridodd,ygridodd,xi)