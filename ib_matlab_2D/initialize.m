clear;

% DO NOT PUT ANYTHING EXCEPT 1 ON THE EDGES
% make sure its square
maze=[1,1,1,1,1,1,1,1,1,1,1,1;
    4,4,4,2,4,4,4,4,4,4,4,4;
    1,1,1,0,1,1,1,1,1,1,1,1;
    1,0,0,0,1,0,0,0,1,1,1,1;
    1,0,1,0,0,0,1,0,1,1,1,1;
    1,0,1,1,1,1,1,0,1,1,1,1;
    1,0,1,0,0,0,0,0,1,1,1,1;
    1,0,1,0,1,1,1,0,1,1,1,1;
    1,0,1,0,0,1,1,0,1,1,1,1;
    1,1,1,1,3,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,1,1,1,1,1;
    1,1,1,1,1,1,1,1,1,1,1,1];

N=72; % number of grid points (needs to divide maze size)
L=1.0; % size of grid
h=L/N; % spacing between grid points
ip=[(2:N),1];
im=[N,(1:(N-1))];
K=5000; % spring force of droplets
K2=5000; % spring force of wall
m=1; % mass of rigidbody points
grav=0.2; % gravity
rho=1; % fluid pressure
mu=0.1; % fluid parameter
tmax=5; % total time to simulate
dt=0.0001; % time stepping
clockmax=ceil(tmax/dt);

Ntemp=1*N/size(maze,1); % twice as many boundary points per fluid point ?
count=1;
for i=0:size(maze,1)-1 % i is distance from the top
    for j=0:size(maze,2)-1 % j is distance from the left
        if maze(i+1,j+1)==4 % horizontal wall
            for k=0:Ntemp
                wallpos(count+k,1)=L*(j)/size(maze,2) + k*L/(1*N);
                wallpos(count+k,2)=L*(1-(i+2)/size(maze,1));
            end
            count=count+Ntemp+1;
        end

        if (maze(i+1,j+1)~=1) && (maze(i+1,j+1)~=4) % normal path
            if ((maze(i,j+1)==1) || (maze(i,j+1)==4)) && (maze(i+1,j+1)~=2) % above
                for k=0:Ntemp
                    wallpos(count+k,1)=L*(j)/size(maze,2) + k*L/(1*N);
                    wallpos(count+k,2)=L*(1-(i+1)/size(maze,1));
                end
                count=count+Ntemp+1;
            end

            if ((maze(i+1,j)==1) || (maze(i,j+1)==4)) % left
                for k=0:Ntemp
                    wallpos(count+k,1)=L*(j)/size(maze,2);
                    wallpos(count+k,2)=L*(1-(i+1)/size(maze,1)) - k*L/(1*N);
                end
                count=count+Ntemp+1;
            end

            if ((maze(i+2,j+1)==1) || (maze(i,j+1)==4))  && (maze(i+1,j+1)~=3) % below
                for k=0:Ntemp
                    wallpos(count+k,1)=L*(j)/size(maze,2) + k*L/(1*N);
                    wallpos(count+k,2)=L*(1-(i+2)/size(maze,1));
                end
                count=count+Ntemp+1;
            end

            if ((maze(i+1,j+2)==1) || (maze(i,j+1)==4)) % right
                for k=0:Ntemp
                    wallpos(count+k,1)=L*(j+1)/size(maze,2);
                    wallpos(count+k,2)=L*(1-(i+1)/size(maze,1)) - k*L/(1*N);
                end
                count=count+Ntemp+1;
            end
        end
    end
end
wallpos = unique(wallpos,'rows'); % remove duplicates

% boundary points
Nb2=size(wallpos,1); % number of boundary points
X2=zeros(Nb2,2);
for k=0:size(wallpos,1)-1
  X2(k+1,1)=wallpos(k+1,1);
  X2(k+1,2)=wallpos(k+1,2);
end
Z2=X2; % target point position

Nb=4*20;
V=zeros(Nb,1); % target point velocity
X=zeros(Nb,2);
counter=1;
for i=1:4
    for j=1:20
        X(counter,1)=0.26+0.02*(i-1);
        X(counter,2)=0.75+0.02*(j-1);
        counter=counter+1;
    end
end
Z=X;

% initial fluid velocity
u=zeros(N,N,2);

% grid positions
xgrid=zeros(N,N);
ygrid=zeros(N,N);
for j=0:(N-1)
  xgrid(j+1,:)=j*h;
  ygrid(:,j+1)=j*h;
end

hold on
plot(X2(:,1),X2(:,2),'.r')
axis([0,L,0,L])
drawnow
hold off

