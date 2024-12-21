function w=skew(u,h,ip,im)
w=u; %note that this is done only to make w the same size as u
w(:,:,1)=sk(u,u(:,:,1),h,ip,im);
w(:,:,2)=sk(u,u(:,:,2),h,ip,im);

