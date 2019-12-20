load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
dir = "C:/cygwin/home/eshchekinova/BlackSea"

begin
;-------- winter  -----------------------------------------------------------------------------------
 
month_abbr = (/"Jan 2017","Feb 2017","Mar 2017","Apr 2017","May 2017","Jun 2017","Jul 2017","Aug 2017","Sep 2017", \
                    "Oct 2017","Nov 2017","Dec 2017"/);

;---------- INPUT DATA FILES--------------------------------------------------------

;uf1 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554708737254.nc","r");  ; Jan 2016-Jan 2017
;uf1 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554709159757.nc","r");  ; Jan 2017-Jan 2018
;uf3 = addfile(dir+"/sv03-bs-cmcc-cur-an-fc-d_1554709422311.nc","r"); ; Jan 2018 - Apr 2019

;---------- INPUT ZONAL AND MERIDIONAL VELOCITY ---------------------------------

SIZE_LATITUDE =215;
SIZE_LONGITUDE =395;
SIZE_TIME = 365;
SIZE_DEPTH = 1;
;DAY = 1;

;---------------------------------------------------------------------------------

;IND_LAT   = ispan(0, SIZE_LATITUDE-1, 1);
;IND_LON   = ispan(0, SIZE_LONGITUDE-1, 1);

;u1  = uf1->vozocrtx(0:SIZE_TIME-1,0:SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)   ; Get u, v, latitude, and longitude data.
;v1 = uf1->vomecrty(0:SIZE_TIME-1,0:SIZE_DEPTH-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1);
 
;   zo_mean_wint=dim_avg_n(u1,1);
 
;   me_mean_wint=dim_avg_n(v1,1);

;   zo_std_wint=dim_stddev_n(u1, 1); 
;   me_std_wint=dim_stddev_n(v1, 1); 
   
;   lat = u1&lat;
;   lon = u1&lon;

;   time = u1&time;
  
  ;utc_date = ut_calendar(time, 0);
  ;year   = tointeger(utc_date(:,0))    ; Convert to integer for
  ;month  = tointeger(utc_date(:,1))    ; use sprinti 
  ;day    = tointeger(utc_date(:,2));
  ;hour   = tointeger(utc_date(:,3));
  ;minute = tointeger(utc_date(:,4));
  ;second = utc_date(:,5);
 ;
 ; Write out strings in the format "dd mmm yyyy".
 ;

  ; date_str = sprinti("%0.2iZ ", hour) + sprinti("%0.2i ", day) + \
            ;  month_abbr(month) + " "  + sprinti("%0.4i", year);
  


;    dimlon=dimsizes(lon);
;    dimlat=dimsizes(lat);
   
;    dimtime=SIZE_TIME;
;    npts=dimlon*dimlat;
;-------------------Read current data from file------
file_curr = "C:/cygwin/home/eshchekinova/BlackSea/CurrentCMCCBlackSea2017_sparse.txt";

ncols = numAsciiCol(file_curr);

nrows=numAsciiRow(file_curr);
data_curr=asciiread(file_curr,(/nrows,ncols/),"float");

dimtime = 12;
dims2=108;
lat=new((/dims2/),"float");
dims1=198;
lon=new((/dims1/),"float");
speed_curr=new((/dimtime,dims2,dims1/),"float");
u_curr=new((/dimtime,dims2,dims1/),"float");
v_curr=new((/dimtime,dims2,dims1/),"float");

lat=get_unique_values(data_curr(:,4));
lon=get_unique_values(data_curr(:,3));

do k=0,dimtime-1

 do i=0,dims2-1
  do j=0,dims1-1

   speed_curr(k,i,j)=data_curr(j+(i+k*dims2)*dims1,2);
   u_curr(k,i,j)=data_curr(j+(i+k*dims2)*dims1,0);
   v_curr(k,i,j)=data_curr(j+(i+k*dims2)*dims1,1);
  end do;
 end do;
end do;  
time=(/1,2,3,4,5,6,7,8,9,10,11,12/);

  ;--------  DRAW MAP  -----------------------------------------------------------------------------------   
 
  wks = gsn_open_wks("pdf","meancurrentBlackSea_Dec") ; Open an pdf workstation.
  gsn_define_colormap(wks,"BlAqGrYeOrReVi200");
  wks1 = gsn_open_wks("x11","meancurrentBlackSea") ; Open an X11 workstation.
  gsn_define_colormap(wks1,"BlAqGrYeOrReVi200");
  wks@wkPaperWidthF=0.5;

  wks@wkPaperHeightF=100;
  ;wks@wkOrientation = "portrait";
  wks@wkPaperSize = "A3";
   wks@wkPaperWidthF=100;
  wks1@wkPaperWidthF=100;

  wks1@wkPaperHeightF=100;
 ; wks1@wkOrientation = "portrait";
  wks1@wkPaperSize = "A3";

;------------------------------------------------------------------------------------
  
  res  = True 
  res@cnFillOn            = True
  res@gsnDraw=False
  res@gsnFrame=False
  res@tiXAxisFont   = "Times-Roman"  ; Change the default font used.
  ;res@tmXBLabelFont = "Times-Roman"
  ;res@tmYLLabelFont = "Times-Roman"
  res@gsnSpreadColors     = True         ; use full colormap

  res@cnLineLabelsOn      = False        ; no contour line labels
 res@cnLinesOn      = False        ; no contour line labels
 
  res@gsnMaximize=True;
  res@tiMainString    = "    "; 
  res@tmXBLabelFontHeightF = 0.02
  res@tmYLLabelFontHeightF= 0.02
  res@pmLabelBarOrthogonalPosF= 0.13
  res@lbOrientation            = "horizontal"
  res@lbLabelPosition          = "right"    ; Move labels to left side of labelbar
  res@mpMaxLatF  = max(lat); select subregion
  res@mpMinLatF  = min(lat);
  res@mpMinLonF  = min(lon);
  res@mpMaxLonF  = max(lon);

  print(max(lat))
  print(min(lat))
  print(max(lon))
  print(min(lon))

  res@gsnAddCyclic=False
   res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
  res@cnLevels    = (/0.1,0.12,0.14,0.16,0.18,0.2,0.22,0.24,0.26,0.28,0.3,0.32,0.34,0.36/)   ; set levels
  ;res@cnLevels    = (/0.01,0.002, 0.03,0.04,0.05/)   ; set levels

 ; res@vpWidthF              =  0.6           ;-- width of viewport                          
 ; res@vpHeightF             =  0.8          ;-- height of viewport    ;-- create the first plot   


res@mpDataBaseVersion    = "HighRes"   

;-----------------Draw vector field and streamline
  vcres                         = True
 
  vcres@tmXBLabelFontHeightF = 0.011
  vcres@tmYLLabelFontHeightF= 0.011
  vcres@vcMonoFillArrowEdgeColor = False
  vcres@tiMainString    = "   "; 
 
  vcres@gsnAddCyclic=False
  vcres@mpCenterLonF     = -100.0
  vcres@mpCenterLatF     =   50.0

  vcres@gsnAddCyclic      = False    ; Don't add cyclic longitude point

  vcres@tiMainString      = "  "

  vcres@vcFillArrowsOn          = True
  vcres@gsnRightString          = ""
  vcres@gsnLeftString           = ""
  vcres@vcRefMagnitudeF         = 10.0             ; define vector ref mag
  vcres@vcRefLengthF            = 1.0             ; define length of vec ref
  vcres@vcMinFracLengthF        = 0.5
  vcres@vcMinDistanceF          = 0.01
    vcres@tmYRlabelsOn          = False
  vcres@vcRefAnnoOrthogonalPosF = -0.45
  vcres@vcRefAnnoFontHeightF    = 0.007  

  vcres@vcRefLengthF         = 0.06313608
  vcres@vcMinFracLengthF     = 0.3
 print(dimsizes(lat))
 print(dimsizes(u_curr))
  u_curr!0="time"
  u_curr!1="latitude"
  u_curr!2="longitude"
  u_curr&time=time
  u_curr&latitude=lat
  u_curr&longitude=lon
  v_curr!0="time"
  v_curr!1="latitude"
  v_curr!2="longitude"
  v_curr&time=time
  v_curr&latitude=lat
  v_curr&longitude=lon
  
  speed_curr!0="time"
  speed_curr!1="latitude"
  speed_curr!2="longitude"
  speed_curr&latitude=lat
  speed_curr&time=time
  speed_curr&longitude=lon
   
  res@gsnAddCyclic=False
  res@tfDoNDCOverlay = True
  
  res@cnInfoLabelOn = False
  res@mpFillDrawOrder       = "PostDraw"     ; draw map fill last

  res@stArrowLengthF     = 0.006                    ; size of the arrows.
 ; res@stMinArrowSpacingF = 0.004                    ; arrow spacing.
 ; res@stArrowStride      = 3                        ; arrows start every third
  res@stLineThicknessF = 3.5
  res@mpGridAndLimbOn= False
  res@cnInfoLabelOn = False                     ; turn off cn info label 
  res1=res; 
  res1@gsnLeftString   = month_abbr(11) 
  
  map1 =gsn_csm_contour_map(wks1,speed_curr(11,::,::),res1);
  map2=gsn_csm_contour_map(wks,speed_curr(11,::,::),res1);

  plot1 =gsn_csm_streamline(wks1,u_curr(11,::5,::5),v_curr(0,::5,::5),res);
  plot2 =gsn_csm_streamline(wks,u_curr(11,::5,::5),v_curr(0,::5,::5),res);
  ;draw(map1)
  ;draw(map2)
  ;maximize_output(wks,True);
  ;maximize_output(wks1,True);
  overlay(map1,plot1)
  overlay(map2,plot2)

  draw(map1)
  draw(map2)
  frame(wks1) 
  frame(wks) 
  delete(res)
  end;