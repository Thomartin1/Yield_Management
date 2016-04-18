

function Update_seatinventory!(bookingclass,flowid,flowlist,seatinventory)
  flights=legfromflow(flowid, flowlist)
  for plane in flights
    if(seatinventory[plane][bookingclass]>0)
      seatinventory -=1
    else return false
    end
  end
  return true
end
