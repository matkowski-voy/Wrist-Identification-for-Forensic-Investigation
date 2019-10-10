function B = pls(X,Y,d)

	Y1 = Y;
	X1 = X;

	W = zeros(size(X,2),d);
	T = zeros(size(X,1),d);
	U = zeros(size(X,1),d);
	for i=1:d
	
		W(:,i) = X'*Y/(Y'*Y);
		W(:,i) = W(:,i)/norm(W);
		T(:,i) = X*W(:,i);%/(W(:,i)'*W(:,i));
		U(:,i) = Y;
		P = X'*T(:,i)/(T(:,i)'*T(:,i));
		
		
		X = X - T(:,i)*P';	
		Y = Y - T(:,i)*T(:,i)'*Y/(T(:,i)'*T(:,i));	
	
	end

% 	B = X1'*U*inv(T'*X1*X1'*U)*T'*Y1;
    B = X1'*U/(T'*X1*X1'*U)*T'*Y1;

end
