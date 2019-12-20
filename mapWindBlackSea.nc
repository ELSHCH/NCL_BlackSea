load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
dir = "C:/cygwin/home/eshchekinova/BlackSea"

begin
;------------------------------------------------------------------------------


;f1     = addfile ("adaptor.mars.external-1554812603.5240307-5221-3-82b88bfa-03ae-4593-bfb6-a5bc567cd511.nc", "r")

;f2     = addfile ("adaptor.mars.external-1554812894.4417913-6530-1-81d33098-3eb3-484c-b456-f4218e948ca7.nc", "r")

;SIZE_LATITUDE =565;
;SIZE_LONGITUDE =565;
;SIZE_TIME1 = 724;
;SIZE_TIME2 = 736;


;SIZE_LATITUDE =100;
;SIZE_LONGITUDE =100;
;SIZE_TIME1 = 72;
;SIZE_TIME2 = 73;

 ; wdir1     = f1->WDIR_P0_L103_GLC0(0:SIZE_TIME1-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
 ; wind1     = f1->WIND_P0_L103_GLC0(0:SIZE_TIME1-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
 ; lat2d = f1->gridlat_0(0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
 ; lon2d = f1->gridlon_0(0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
 ; rot_angle= f1->gridrot_0(0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
 ; time1 =  f1->initial_time0_hours(0:SIZE_TIME1-1)
 ; time2 =  f2->initial_time0_hours(0:SIZE_TIME2-1)

 ; wdir2     = f2->WDIR_P0_L103_GLC0(0:SIZE_TIME2-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)
 ; wind2     = f2->WIND_P0_L103_GLC0(0:SIZE_TIME2-1,0:SIZE_LATITUDE-1,0:SIZE_LONGITUDE-1)


 ; wdir = array_append_record (wdir1, wdir2, 0)
 ; wind = array_append_record (wind1, wind2, 0)
 ; time = array_append_record (time1, time2, 0)
  
datafile1 = "C:/cygwin/home/eshchekinova/BlackSea/windBlackSeaNetcdf.txt";
  ncols1=numAsciiCol(datafile1);
  nrows1=numAsciiRow(datafile1);
  
  data=asciiread(datafile1,(/nrows1,ncols1/),"float");
  
 
  dimlat = 33;
  dimlon = 65;

  dimtime = 362;

  winddir=new((/dimlat,dimlon,dimtime/),"float");
  windspeed = new((/dimlat,dimlon,dimtime/),"float");
  windspeed_monthly=new((/dimlat,dimlon,12/),"float")
  ugrid = new((/dimlat,dimlon,dimtime/),"float");
  vgrid = new((/dimlat,dimlon,dimtime/),"float");
  ugrid_monthly = new((/dimlat,dimlon,12/),"float");
  vgrid_monthly = new((/dimlat,dimlon,12/),"float");

  lon = new((/dimlon/),"float");
  lat = new((/dimlat/),"float");


  do j=0,dimtime-1

  do k=0,dimlat-1
  do i=0,dimlon-1
   
  lon(i) = data(i+(k+j*dimlat)*dimlon,3);
  lat(k) = data(i+(k+j*dimlat)*dimlon,4);
  
  
   vgrid(dimlat-1-k,i,j) = data(i+(k+j*dimlat)*dimlon,1);
   ugrid(dimlat-1-k,i,j) = data(i+(k+j*dimlat)*dimlon,0);
   windspeed(dimlat-1-k,i,j)=sqrt(ugrid(dimlat-1-k,i,j)^2+vgrid(dimlat-1-k,i,j)^2);
  

  end do
  end do
  end do
 print(lat)
days_start= (/0,31,59,91,122,154,185,216,247,278,310,341/);
  print(dimsizes(windspeed))
  days_end=(/30,58,90,121,153,184,215,246,277,309,340,361/);
  do j=0,11
  do k=0,dimlat-1
  do i=0,dimlon-1

     windspeed_monthly(k,i,j)=dim_avg_n(windspeed(k,i,days_start(j):days_end(j)),0);
     vgrid_monthly(k,i,j)=dim_avg_n(vgrid(k,i,days_start(j):days_end(j)),0);
     ugrid_monthly(k,i,j)=dim_avg_n(ugrid(k,i,days_start(j):days_end(j)),0);

  end do
  end do
  end do

  lat@units="degrees_north";
  lon@units="degrees_east";
  ugrid!0="latitude";
  ugrid!1="longitude";
  ugrid&latitude=lat;
  ugrid&longitude=lon;

  windspeed!0="latitude";
  windspeed!1="longitude";
  windspeed&latitude=lat;
  windspeed&longitude=lon;

  vgrid!0="latitude";
  vgrid!1="longitude";
  vgrid&latitude=lat;
  vgrid&longitude=lon;

  ugrid_monthly!0="latitude";
  ugrid_monthly!1="longitude"; 
  ugrid_monthly&latitude=lat;
  ugrid_monthly&longitude=lon;

  vgrid_monthly!0="latitude";
  vgrid_monthly!1="longitude"; 
  vgrid_monthly&latitude=lat;
  vgrid_monthly&longitude=lon;

  windspeed_monthly!0="latitude";
  windspeed_monthly!1="longitude"; 
  windspeed_monthly&latitude=lat;
  windspeed_monthly&longitude=lon;

  ;vearth&initial_time0_hours=wind&initial_time0_hours
  ;vearth&gridlat_0@units="degrees_north"
  ;vearth&gridlon_0@units="degrees_east"

  ;w_speed!1="ygrid_0"
  ;w_speed!2="xgrid_0"
  ;w_speed!0 = "initial_time0_hours"

  ;w_speed&initial_time0_hours=wind&initial_time0_hours
  ;w_speed&ygrid_0=wind&ygrid_0
  ;w_speed&xgrid_0=wind&xgrid_0

;--------------------------------------------------
; set resources and create plot
;--------------------------------------------------
  wks  = gsn_open_wks ("pdf", "WindBlackSea2017_3")         ; open workstation
  wks1 = gsn_open_wks("x11","WindBlackSea") ; Open an X11 workstation.
  cmap = read_colormap_file("gui_default")        ; so we can subset later

  wks@wkPaperWidthF=0.5;

  wks@wkPaperHeightF=1.0;
  wks@wkOrientation = "portrait";
  wks@wkPaperSize = "A3";
   wks@wkPaperWidthF=100;
  wks1@wkPaperWidthF=100;

  wks1@wkPaperHeightF=100;
 wks1@wkOrientation = "portrait";
  wks1@wkPaperSize = "A3";


  res                        = True               ; plot mods desired
  res@gsnDraw                 = False
  res@gsnFrame                = False
  res@cnFillOn               = True               ; color fill  
  res@cnFillPalette          = cmap(2:,:)         ; subset the color map
  res@cnLinesOn              = False              ; no contour lines
  res@cnLineLabelsOn         = True              ; no contour labels
  res@cnInfoLabelOn          = True              ; no contour info label
  res@lbLabelBarOn = True
  

  res@vpWidthF              =  0.5           ;-- width of viewport                          
  res@vpHeightF             =  1.0          ;-- height of viewport    ;-- create the first plot   

  
  res@mpDataBaseVersion      = "MediumRes"        ; better map outlines
  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  
  res@tiMainString           = "  "
  res@tiMainFontHeightF      = 0.020              ; smaller title
  res@tiMainOffsetYF         = -0.005             ; move title down
  
  res@gsnAddCyclic           = False              ; regional data
  res@gsnMaximize            = True               ; enlarge image  
  str = (/"January 2017, ERA5","February 2017","March 2017","April 2017","May 2017","June 2017","July 2017, ERA5","August 2017 ","September 2017","October 2017,","November 2017","December 2017"/)
  



  ;---Add resource for wind vector plot ---------------------
 res@vcRefLengthF         = 0.01  ;some floating point value
  res@vcRefMagnitudeF      = 0.1  ;some floating point value

  ;res@vcMinFracLengthF     = 0.05     ; length of min vector as fraction
                                      ; of reference vector.

  res@vcMinDistanceF       = 0.02     ; "thin" vectors

  res@vcMonoLineArrowColor = False    ; color arrows based on magnitude
  res@vcLevelPalette       = "rainbow"         ; define colormap for vectors

  res@vcGlyphStyle    = "WindBarb"     ; turn on curly vectors
  res@cnLinesOn = False
  res@cnFillOn = True
  res@cnLevelSelectionMode = "ExplicitLevels" 
  res@cnLevels =  (/0,2,4,6,8,10,12,14,18,20/) 

  ; -------------------------------------------------------------------

  res@mpMaxLatF  = max(lat); select subregion
  res@mpMinLatF  = min(lat);
  res@mpMinLonF  = min(lon);
  res@mpMaxLonF  = max(lon);

  res@mpDataBaseVersion    = "HighRes" 
  res@lbTitleOn = False


  res1                        = True               ; plot mods desired
  res1@gsnDraw                 = False
  res1@gsnFrame                = False
  res1@cnFillOn               = True               ; color fill  
  res1@cnFillPalette          = cmap(2:,:)         ; subset the color map
  res1@cnLinesOn              = False              ; no contour lines
  res1@cnLineLabelsOn         = True              ; no contour labels
  res1@cnInfoLabelOn          = True              ; no contour info label
  res1@lbLabelBarOn = True

  
  res1@mpDataBaseVersion      = "MediumRes"        ; better map outlines
  res1@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  
  res1@tiMainString           = "  "
  res1@tiMainFontHeightF      = 0.020              ; smaller title
  res1@tiMainOffsetYF         = -0.005             ; move title down
  
  res1@gsnAddCyclic           = False              ; regional data
  res1@gsnMaximize            = True               ; enlarge image 
  
  res1@lbLabelPosition  = -1.02
  res1@pmLabelBarWidthF          = 1.05
  res1@pmLabelBarParallelPosF     = -0.02

  ;---Add resource for wind vector plot ---------------------
  res1@vcRefLengthF         = 0.01  ;some floating point value
  res1@vcRefMagnitudeF      = 0.01  ;some floating point value

  res1@vcMinFracLengthF     = 0.05     ; length of min vector as fraction
                                      ; of reference vector.

  res1@vcMinDistanceF       = 0.02     ; "thin" vectors

  res1@vcMonoLineArrowColor = False    ; color arrows based on magnitude
  res1@vcLevelPalette       = "rainbow"         ; define colormap for vectors

  res1@vcGlyphStyle         = "WindBarb"     ; turn on curly vectors
  res1@cnLinesOn = False
  res1@cnFillOn = True
  res1@cnLevelSelectionMode = "ExplicitLevels" 
  res1@cnLevels =  (/0,0.5, 1, 1.5,2,2.5, 3, 3.5,4/) 

  ; -------------------------------------------------------------------

  res1@mpMaxLatF  = max(lat); select subregion
  res1@mpMinLatF  = min(lat);
  res1@mpMinLonF  = min(lon);
  res1@mpMaxLonF  = max(lon);

  res1@mpDataBaseVersion    = "HighRes"  

  
  vcres                         = True
  vcres@gsnDraw                 = False
  vcres@gsnFrame                = False


  vcres@vcFillArrowsOn           = False
  vcres@vcLineArrowThicknessF    =  1.0

  vcres@vcMinFracLengthF         = 0.33
  vcres@vcMinMagnitudeF          = 0.1
  vcres@vcMonoFillArrowFillColor = True
  ;vcres@vcMonoLineArrowColor     = False

  vcres@vcRefLengthF             = 0.045
  vcres@vcRefMagnitudeF          = 5.0
  vcres@vcAnnoFontHeightF = 0.01
  vcres@vcLabelFontHeightF = 0.1
  vcres@vcRefAnnoPerimSpaceF = 0.02
  vcres@vcRefAnnoOrthogonalPosF  = -0.8
  vcres@vcRefAnnoParallelPosF    =  0.997
  vcres@vcRefAnnoFontHeightF     = 0.015


  
; Usually, when data is placed onto a map, it is TRANSFORMED to the specified
; projection. Since this model is already on a native lambert conformal grid,
; we want to turn OFF the transformation.
  
  res@tfDoNDCOverlay = True

  res@cnInfoLabelOn = False
; res@tfDoNDCOverlay = "NDCViewport"               ; can use in V6.5.0 and later
  plot = new(6,graphic)  
  plot1 = new(6,graphic) 
   

  do i=0,3 
  res@gsnLeftString   = str(i+8) 
  plot(i) = gsn_csm_contour_map(wks,windspeed_monthly(::2,::2,i+8),res)     ; Draw contours over a map.
  vector = gsn_csm_vector(wks,ugrid_monthly(::2,::2,i+8),vgrid_monthly(::2,::2,i+8),vcres) 

  plot1(i) = gsn_csm_contour_map(wks1,windspeed_monthly(::2,::2,i+8),res)     ; Draw contours over a map.
  vector1 = gsn_csm_vector(wks1,ugrid_monthly(::2,::2,i+8),vgrid_monthly(::2,::2,i+8),vcres)
  ;draw(plot(i));
  ;draw(plot1(i)); 
  overlay(plot(i),vector);
  overlay(plot1(i),vector1);


  end do;


  res@gsnLeftString   = str(5) 
  plot(5) = gsn_csm_contour_map(wks,windspeed(::2,::2,5),res)     ; Draw contours over a map.
  vector = gsn_csm_vector(wks,ugrid(::2,::2,5),vgrid(::2,::2,5),vcres) 

  plot1(5) = gsn_csm_contour_map(wks1,windspeed(::2,::2,5),res)     ; Draw contours over a map.
  vector1 = gsn_csm_vector(wks1,ugrid(::2,::2,5),vgrid(::2,::2,5),vcres)
  ;draw(plot(5));
  ;draw(plot1(5)); 
  overlay(plot(5),vector);
  overlay(plot1(5),vector1);


  gsn_panel(wks,plot,(/2,2/),False)
  gsn_panel(wks1,plot1,(/2,2/),False)
  
  frame(wks);
  frame(wks1);

end;

