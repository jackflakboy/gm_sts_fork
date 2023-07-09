if ( SERVER ) then

	util.AddNetworkString( "pointUpdate" )
	function pointUpdate(points)

		net.Start( "pointUpdate" )
			net.WriteInt( points )
		net.Broadcast()
	end

else

	net.Receive( "pointUpdate", function( len, ply )
		points = net.ReceiveInt()
	end )

end