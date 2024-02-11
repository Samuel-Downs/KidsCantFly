
import Visualizer,STD,$;
HMK := $.File_AllData;

cities:= HMK.City_DS;
church:= HMK.ChurchDS;
missKids:= HMK.mc_byStateDS;

churchCity:= RECORD
  church.name;
  // church.city;
  // cities.city;
  cities.county_fips;
  end;
  
churchCityDS:= JOIN(cities, church, STD.STR.ToUpperCase(LEFT.city) = RIGHT.city
                                              and LEFT.state_id = RIGHT.state,
                                              TRANSFORM(churchCity,
                                              SELF:= LEFT,
                                              SELF:= RIGHT));
  
OUTPUT(churchCityDS, NAMED('Church_City_DS'));




missKidCity:= RECORD
  missKids.firstname;
  missKids.lastname;
  missKids.missingcity;
  cities.city;
  cities.county_fips;
  end;
  
missKidCityDS:= JOIN(cities, misskids, LEFT.city = RIGHT.missingcity
                                              and LEFT.state_id = RIGHT.missingstate,
                                              TRANSFORM(missKidCity,
                                              SELF:= LEFT,
                                              SELF:= RIGHT));
OUTPUT(missKidCityDS, NAMED('Missing_Kid_City')); 
  
  
// finalResult:= RECORD
  // missKidCityDS.firstname;
  // missKidCityDS.lastname;
  // missKidCityDS.city;
  // churchCityDS.name;
  // churchCityDS.county_fips;
  // end;
  
  // puttingItAllTogether:= JOIN(churchCityDS, missKidCityDS, LEFT.county_fips = RIGHT.county_fips,
                                              // TRANSFORM(finalResult,
                                              // SELF:= LEFT,
                                              // SELF:= RIGHT));
// OUTPUT(puttingItAllTogether, NAMED('Church_City_Missing_Kids'));
  
  // groupbyRec:= RECORD
  // puttingItAllTogether.
  
  crosstabKidFipsRec:= RECORD
  missKidCityDS.county_fips;
  end;
  
  groupByKidsFips:= RECORD
  countMissingKids:= COUNT(GROUP);
  crosstabKidFipsRec;
  END;
  
  groupByKidsFipsDS:= TABLE(missKidCityDS, groupByKidsFips, county_fips);
  OUTPUT(SORT(groupByKidsFipsDS,RECORD), NAMED('Number_Of_Kids_Missing_Per_Fip'),ALL);
  
  
 crossTabChurchFipRec:= RECORD
 churchCityDS.county_fips;
 END;
 
 groupByChurchFip:= RECORD
 crossTabChurchFipRec;
 countOfChurches := COUNT(GROUP);
 END;
 
 groupByChurchFipDS := TABLE(churchCityDS, groupByChurchFip, county_fips);
 OUTPUT(groupByChurchFipDS, NAMED('Number_Of_Courches_In_Fip'),ALL);
 
 groupedKidChurches:= RECORD
 // groupByKidsFipsDS.county_fips;
 groupByChurchFipDS.countOfChurches;
 groupByKidsFipsDS.countMissingKids;
 END;
 
 numberOfKidsChurchesPerFipDS := JOIN(groupByKidsFipsDS, groupByChurchFipDS, LEFT.county_fips = RIGHT.county_fips,
                                                           TRANSFORM(groupedKidChurches, SELF := LEFT,
                                                                                         SELF := RIGHT),ALL);
 OUTPUT(SORT(numberOfKidsChurchesPerFipDS, RECORD), NAMED('Number_Of_Kids_To_Church_Per_Fip'),ALL);
 Visualizer.MultiD.Scatter('scatter',, 'Number_Of_Kids_To_Church_Per_Fip');
 
// maxOutpuT:= RECORD
// DATASET(numberOfKidsChurchesPerFipDS{MAXCOUNT(1000)});
// END;
  // OUTPUT(SORT(maxOutpuT, RECORD), NAMED('Number_Of_Kids_To_Church_Per_Fip1'));
// Visualizer.MultiD.Scatter('scatter',, 'Number_Of_Kids_To_Church_Per_Fip1');
  
  //OUTPUTS