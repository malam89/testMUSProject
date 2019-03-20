/**
    Description : This class Used to send Mock response for http calls to EON JUMBO.
    Test Class  : 
**/

/*
    Created By   : ArunaManjari
    Created Date : 22/04/2016
    Service Req : SR_EON_Jumbo_022
    Change history:
	CH01 # SR_EON_Jumbo_046 # 25/07/2016 # Mahadev Joshilkar # Update code coverage
	CH02# SR_EON_Jumbo_062 # 25/07/2016 # Mahadev Joshilkar # Update code coverage
	
*/
@isTest
global class EON_JUMBO_Gas_WebServiceMockImpl implements WebServiceMock{
    public static string methodType = ''; //CH02.New
   	global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType){
		String[] Msg = new String[]{'Message1','Message2','Message3'};
      	EON_JUMBO_Work_Management_WS.ErrorList err = new EON_JUMBO_Work_Management_WS.ErrorList();
      	err.Message = Msg;
      	EON_JUMBO_Work_Management_WS.GasAddress gasAdd = new EON_JUMBO_Work_Management_WS.GasAddress ();
      	gasAdd.AddressText='AddressText';
      	if(EON_JUMBO_Create_GasJob_In_Isis_WS_Test.errFlag) 
        	gasAdd.Building=null;
       	else
        	gasAdd.Building='AddressText';
      	gasAdd.DependentLocality='AddressText';
      	gasAdd.County='County';
      	if(EON_JUMBO_Create_GasJob_In_Isis_WS_Test.errFlag) 
        	gasAdd.DependentThoroughfare=null;
      	else
        	gasAdd.DependentThoroughfare='DependentThoroughfare';
     	gasAdd.DoubleDependentLocality='DoubleDependentLocality';
      	if(EON_JUMBO_Create_GasJob_In_Isis_WS_Test.errFlag)
        	gasAdd.PostCode=null;
       	else 
        	gasAdd.PostCode='PostCode';
      	gasAdd.PostTown='PostTown';
      	gasAdd.PostTown='PostTown';
      	gasAdd.SubBuilding='SubBuilding';
      	gasAdd.UPRN='UPRN';
      	if(EON_JUMBO_Create_GasJob_In_Isis_WS_Test.errFlag) 
        	gasAdd.Thoroughfare=null;
      	else
        	gasAdd.Thoroughfare='Thoroughfare';
      
      	EON_JUMBO_Work_Management_WS.GasRegister gRegi = new EON_JUMBO_Work_Management_WS.GasRegister();
      	gRegi.MultiplicationFactor = '3';
      	gRegi.NumberOfDigits = '2';
      	//gRegi.Reading = '0'; //CH01.Old
      	//gRegi.Removed = '1'; //CH01.Old
      	gRegi.UnitsOfMeasure = 'UNCOR';
     
      	EON_JUMBO_Work_Management_WS.GasRegister[] objGasReg = new EON_JUMBO_Work_Management_WS.GasRegister[]{gRegi};          
     	EON_JUMBO_Work_Management_WS.ArrayOfGasRegister arrGReg = new EON_JUMBO_Work_Management_WS.ArrayOfGasRegister(); 
      	arrGReg.GasRegister = objGasReg;
            
      	EON_JUMBO_Work_Management_WS.GasMeter gMet = new EON_JUMBO_Work_Management_WS.GasMeter();
      	gMet.CollarStatus = 'CollarStatus';
      	gMet.Location = 'AT';
      	gMet.LocationNotes = 'LocationNotes';      
      	gMet.Manufacturer = 'Manufacturer';
      	gMet.MeasuringCapacity = 'MeasuringCapacity';
      	gMet.Mechanism = 'GM';
      	gMet.Model = 'Model';
      	gMet.PaymentMethod='Pay';
      	gMet.PulseValue = '789';
      	//gMet.Removed='Removed';   //CH01.Old
      	gMet.SerialNumber='1245';
      	gMet.Status='Status';
      	gMet.Type_x='P';
      	gMet.Usage='Usage';
      	gMet.YearOfManufacture = '2015';
      	gMet.Registers = arrGReg;     
      
      	EON_JUMBO_Work_Management_WS.GasMeter[] objGasMet = new EON_JUMBO_Work_Management_WS.GasMeter[]{gMet};          
      	EON_JUMBO_Work_Management_WS.ArrayOfGasMeter arrGMeter = new EON_JUMBO_Work_Management_WS.ArrayOfGasMeter(); 
      	arrGMeter.GasMeter = objGasMet;      

       	EON_JUMBO_Work_Management_WS.GasAppointedParty gasAObj = new EON_JUMBO_Work_Management_WS.GasAppointedParty(); 
       	gasAObj.EffectiveFromDate ='2015-04-23';
       	gasAObj.EffectiveToDate='2016-08-23';
       	gasAObj.AbbreviatedName='MOR';
       
       	EON_JUMBO_Work_Management_WS.Converter conver = new EON_JUMBO_Work_Management_WS.Converter();
       	conver.SerialNumber = '007';
       	conver.Model = 'Model';
       	conver.AssetClass = 'AssetClass';
       	conver.Manufacturer='Manufacturer';
       	conver.Location = 'Location';

       	EON_JUMBO_Work_Management_WS.Converter[] objConver = new EON_JUMBO_Work_Management_WS.Converter[]{conver};
       	EON_JUMBO_Work_Management_WS.ArrayOfConverter arrConver = new EON_JUMBO_Work_Management_WS.ArrayOfConverter();
       	arrConver.Converter = objConver;

       	EON_JUMBO_Work_Management_WS.ContactMechanism contMec = new EON_JUMBO_Work_Management_WS.ContactMechanism();
       	contMec.Code = 'VISIT';
       	contMec.Value = '007';       
       
       	EON_JUMBO_Work_Management_WS.ContactMechanism[] objContMec = new EON_JUMBO_Work_Management_WS.ContactMechanism[]{contMec};
       	EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism arrContMec = new EON_JUMBO_Work_Management_WS.ArrayOfContactMechanism();
       	arrContMec.ContactMechanism = objContMec;
       
       	EON_JUMBO_Work_Management_WS.Contact cont = new EON_JUMBO_Work_Management_WS.Contact();
       	cont.TypeCode = 'UNCON';
       	cont.Initials = 'Initials';
       	cont.Surname = 'Surname';
       	cont.Title = 'Title';
       	cont.ContactMechanism = arrContMec;
       	//cont.CareDetails = ;
       
       	EON_JUMBO_Work_Management_WS.Contact[] objCont = new EON_JUMBO_Work_Management_WS.Contact[]{cont};
       	EON_JUMBO_Work_Management_WS.ArrayOfContact arrCont = new EON_JUMBO_Work_Management_WS.ArrayOfContact();
       	arrCont.Contact = objCont;
                 
       	EON_JUMBO_Work_Management_WS.gasCustomer gCust = new EON_JUMBO_Work_Management_WS.gasCustomer();
       	gCust.AccessInstructions = 'AccessInstructions';
       	gCust.AccessPassword = 'AccessPassword';
       	gCust.ConversionFactor= 'ConversionFactor';
       	gCust.LastInspectionDate= 'LastInspectionDate';
       	gCust.Location= 'Location';
       	gCust.LocationNotes= 'LocationNotes';
       	gCust.MPRN= 'MPRN';
       	gCust.MeterLink= 'MeterLink';
       	gCust.MeterPointStatus= 'MeterPoint';
       	gCust.MeteringPressure= '0.075';
       	gCust.Address=gasAdd;
       	gCust.Meters = arrGMeter;
       	gCust.Supplier = gasAObj;
       	gCust.Converters = arrConver;
       	gCust.Contacts = arrCont;
       
       	EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse resp = new EON_JUMBO_Work_Management_WS.gasMeterPointDataResponse();
       	resp.Errors = err;
       	resp.Success = true;
       	resp.Customer = gCust;
       
       	EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element obj = new EON_JUMBO_Work_Management_WS.RequestGasMeterPointDataResponse_element();    
        obj.RequestgasMeterPointDataResult = resp;
      	//response.put('response_x', obj);   //CH02.Old
      	//CH02.New.Start
        if(request instanceof EON_JUMBO_Work_Management_WS.RequestGasMeterPointData_element){
            if(methodType == 'errorResponse'){
                resp.Success = false;
                response.put('response_x', obj);
            }
            else{
                resp.Success = true;
                response.put('response_x', obj);
            }
		}
       	if(request instanceof  EON_OFSC_Inbound_WS.InboundInterfaceElement){
        	EON_OFSC_Inbound_WS.ReportMessageElement message = new EON_OFSC_Inbound_WS.ReportMessageElement();
            message.result = 'success';
            message.code = '0';
            message.description = 'Appointment id = 126';
            EON_OFSC_Inbound_WS.ReportMessageElement[] messages = new EON_OFSC_Inbound_WS.ReportMessageElement[]{message};
            EON_OFSC_Inbound_WS.ReportElement reports = new EON_OFSC_Inbound_WS.ReportElement();
            reports.message = messages;
            EON_OFSC_Inbound_WS.AppointmentResponseElement appointment = new EON_OFSC_Inbound_WS.AppointmentResponseElement();
            appointment.appt_number = 'test';
            appointment.name = 'test';
            appointment.aid = 126;
            appointment.report = reports;
            EON_OFSC_Inbound_WS.CommandResponseElement command = new EON_OFSC_Inbound_WS.CommandResponseElement();
            command.appointment = appointment;
            EON_OFSC_Inbound_WS.CommandResponseElement[] commandarray = new EON_OFSC_Inbound_WS.CommandResponseElement[]{command};
            EON_OFSC_Inbound_WS.CommandsResponseArray commands = new EON_OFSC_Inbound_WS.CommandsResponseArray();
            commands.command = commandarray;
            EON_OFSC_Inbound_WS.DataResponseElement data = new EON_OFSC_Inbound_WS.DataResponseElement();
            data.commands = commands;
            EON_OFSC_Inbound_WS.InboundInterfaceResponseElement res = new EON_OFSC_Inbound_WS.InboundInterfaceResponseElement();
            res.user_x = new EON_OFSC_Inbound_WS.UserElement();
            res.head = new EON_OFSC_Inbound_WS.HeadResponseElement();
            res.data = data;
           	response.put('response_x', res);
		}
        //CH02.New.End
	}
}