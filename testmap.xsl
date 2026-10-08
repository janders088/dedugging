<?xml version="1.0" encoding="UTF-16"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var" exclude-result-prefixes="msxsl var s1 s2 s0 ns2" version="1.0" xmlns:s1="http://GAL.ESB.DataHub.BizTalk.Common.Canonical.Types" xmlns:ns0="http://www.iata.org/IATA/2007/00" xmlns:s2="http://GAL.ESB.DataHub.BizTalk.Common.Canonical.Flights" xmlns:s0="http://GAL.ESB.DataHub.BizTalk.Common.Canonical.FlightData" xmlns:ns2="http://GAL.ESB.DataHub.BizTalk.Interfaces.AIDX.TPA_Extensions.1_01" xmlns:ScriptNS0="http://schemas.microsoft.com/BizTalk/2003/ScriptNS0" xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp" xmlns:ScriptNS1="http://schemas.microsoft.com/BizTalk/2003/ScriptNS1" xmlns:ScriptNS3="http://schemas.microsoft.com/BizTalk/2003/ScriptNS3">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="/s2:Flights" />
  </xsl:template>
  <xsl:template match="/s2:Flights">
    <xsl:variable name="var:v1" select="userCSharp:StringConcat(&quot;0&quot;)" />
    <xsl:variable name="var:v3" select="userCSharp:StringConcat(&quot;15.1&quot;)" />
    <xsl:variable name="var:v4" select="userCSharp:StringConcat(&quot;FlightData&quot;)" />
    <xsl:variable name="var:v5" select="userCSharp:StringConcat(&quot;1&quot;)" />
    <xsl:variable name="var:v6" select="userCSharp:StringConcat(&quot;Continuation&quot;)" />

    <ns0:IATA_AIDX_FlightLegNotifRQ>
      <xsl:attribute name="EchoToken">
        <xsl:value-of select="$var:v1" />
      </xsl:attribute>
      <xsl:attribute name="TimeStamp">
        <xsl:value-of select="s1:Header/Routing/Simple/CreateDateTime/text()" />
      </xsl:attribute>
      <xsl:variable name="var:v2" select="ScriptNS3:GetConfigValue(&quot;Aidx.Environment&quot;)" />
      <xsl:attribute name="Target">
        <xsl:value-of select="$var:v2" />
      </xsl:attribute>
      <xsl:attribute name="Version">
        <xsl:value-of select="$var:v3" />
      </xsl:attribute>
      <xsl:attribute name="TransactionIdentifier">
        <xsl:value-of select="$var:v4" />
      </xsl:attribute>
      <xsl:attribute name="SequenceNmbr">
        <xsl:value-of select="$var:v5" />
      </xsl:attribute>
      <xsl:attribute name="TransactionStatusCode">
        <xsl:value-of select="$var:v6" />
      </xsl:attribute>
      <ns0:Originator>
     <xsl:attribute name="CompanyShortName">
          <xsl:value-of select="s1:Header/Routing/Simple/Source/text()" />
        </xsl:attribute>
      </ns0:Originator>
      <ns0:DeliveringSystem>
        <xsl:attribute name="CompanyShortName">
          <xsl:value-of select="s1:Header/Routing/Simple/Source/text()" />
        </xsl:attribute>
      </ns0:DeliveringSystem>
      <xsl:for-each select="Body/s0:FlightData">
        <ns0:FlightLeg>
          <xsl:variable name="var:TODO">TODO</xsl:variable>
          <xsl:variable name="var:LGW">LGW</xsl:variable>
          <xsl:variable name="var:IdahoArrDep" select="string(ARR_DEP/text())" />
          <xsl:variable name="var:IsArrival" select="userCSharp:LogicalEq($var:IdahoArrDep , &quot;A&quot;)" />
          <xsl:variable name="var:IsDeparture" select="userCSharp:LogicalEq($var:IdahoArrDep , &quot;D&quot;)" />
          <xsl:variable name="var:dummy1" select="userCSharp:ResetIndexes()" />
          <xsl:variable name="var:arrdep">
            <xsl:choose>
              <xsl:when test="ARR_DEP/text() = 'D'">Departure</xsl:when>
              <xsl:when test="ARR_DEP/text() = 'A'">Arrival</xsl:when>
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="var:flightno" select="userCSharp:ReplaceFlightNo(FLYT_NO/text(), QUEBEC/text())" />
          <ns0:LegIdentifier>
            <ns0:Airline>
              <!--<xsl:variable name="var:v1" select="ScriptNS0:GetIataOrIcaoType(string(OP_CODE/text()))" />
              <xsl:attribute name="CodeContext">
                <xsl:value-of select="$var:v1" />
              </xsl:attribute>-->
              <xsl:value-of select="OP_CODE/text()" />
            </ns0:Airline>
            <ns0:FlightNumber>
              <!--<xsl:value-of select="FLYT_NO/text()" />-->
              <xsl:value-of select="$var:flightno" />
            </ns0:FlightNumber>
            <xsl:if test="QUEBEC">
              <ns0:OperationalSuffix>
                <xsl:value-of select="QUEBEC/text()" />
              </ns0:OperationalSuffix>
            </xsl:if>
            <ns0:DepartureAirport>
              <xsl:if test="string($var:IsDeparture)='true'">
                <xsl:value-of select="$var:LGW" />
              </xsl:if>
              <xsl:if test="string($var:IsArrival)='true'">
                <xsl:variable name="var:ClosestViaDep">
                  <xsl:choose>
                    <xsl:when test="IATA_LOC2">
                      <xsl:value-of select="IATA_LOC2/text()" />
                    </xsl:when>
                    <xsl:when test="IATA_LOC1">
                      <xsl:value-of select="IATA_LOC1/text()" />
                    </xsl:when>
                    
                    <!--<xsl:when test="IATA_LOC3">
                      <xsl:value-of select="IATA_LOC3/text()" />
                    </xsl:when>
                    <xsl:when test="IATA_LOC4">
                      <xsl:value-of select="IATA_LOC4/text()" />
                    </xsl:when>
                    <xsl:when test="IATA_LOC5">
                      <xsl:value-of select="IATA_LOC5/text()" />
                    </xsl:when>-->
                    <!--<xsl:when test="IATA_LOC6">
                      <xsl:value-of select="IATA_LOC6/text()" />
                    </xsl:when>-->
                  </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$var:ClosestViaDep" />
              </xsl:if>
            </ns0:DepartureAirport>
            <ns0:ArrivalAirport>
              <xsl:if test="string($var:IsDeparture)='true'">
                <!--departure-->
                <xsl:variable name="var:ClosestViaArr">
                  <xsl:choose>
                    <xsl:when test="IATA_LOC1">
                      <xsl:value-of select="IATA_LOC1/text()" />
                    </xsl:when>
                    <xsl:when test="IATA_LOC2">
                      <xsl:value-of select="IATA_LOC2/text()" />
                    </xsl:when>
                  </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$var:ClosestViaArr" />
              </xsl:if>
              <xsl:if test="string($var:IsArrival)='true'">
                <!--arrival-->
                <xsl:value-of select="$var:LGW" />
              </xsl:if>
            </ns0:ArrivalAirport>
            <xsl:if test="ORIGIN_STO">
              <ns0:OriginDate>
                <xsl:value-of select="ScriptNS0:GetXsdDate(string(ORIGIN_STO/text()))" />
              </ns0:OriginDate>
            </xsl:if>
          </ns0:LegIdentifier>
          <!--</xsl:for-each>
        <xsl:for-each select="Body/s0:FlightData">-->
          <xsl:variable name="var:v10">Idaho</xsl:variable>
          <xsl:variable name="var:v15" select="string(CHKIN_INFO/text())" />
          <xsl:variable name="var:v17" select="string(DIV_FLG/text())" />
          <xsl:variable name="var:v19" select="string(STATUS/text())" />
          <xsl:variable name="var:v21" select="string(GATE_STATUS/text())" />
          <xsl:variable name="var:v24" select="userCSharp:LogicalExistence(boolean(DIV_LOC))" />
          <xsl:variable name="var:v431" select="userCSharp:StringConcat(&quot;RMK&quot;)" />
          <xsl:variable name="var:v44" select="userCSharp:StringConcat(&quot;9932&quot;)" />
          <xsl:variable name="var:v45" select="userCSharp:StringConcat(&quot;Planned&quot;)" />
          <xsl:variable name="var:v51" select="userCSharp:LogicalExistence(boolean(GAPIER))" />
          <xsl:variable name="var:v52" select="userCSharp:LogicalExistence(boolean(STND))" />
          <xsl:variable name="var:v53" select="userCSharp:LogicalExistence(boolean(PUBLIC_GATE))" />
          <xsl:variable name="var:v57" select="userCSharp:LogicalExistence(boolean(SECOND_TERM))" />
          <xsl:variable name="var:v58" select="userCSharp:LogicalExistence(boolean(CREW_CHANGE_FLG))" />
          <xsl:variable name="var:v59" select="userCSharp:LogicalExistence(boolean(COACHED))" />
          <xsl:variable name="var:v60" select="userCSharp:LogicalExistence(boolean(CAROUSEL))" />
          <xsl:variable name="var:v61" select="userCSharp:LogicalExistence(boolean(CAROUSEL2))" />
          <xsl:variable name="var:v62" select="userCSharp:LogicalOr(string($var:v60) , string($var:v61))" />
          <xsl:variable name="var:v680" select="userCSharp:MathAdd(string(FRT_WGHT/text()) , string(MAIL_WGHT/text()))" />
          <xsl:variable name="var:v681" select="string(OP_CODE/text())" />
          <ns0:LegData>
            <xsl:if test="DICE">
              <xsl:variable name="var:dice" select="DICE/text()" />
              <xsl:attribute name="InternationalStatus">
                <xsl:choose>
                  <xsl:when test="$var:dice = 'D'">Domestic</xsl:when>
                  <xsl:when test="$var:dice = 'I'">International</xsl:when>
                  <xsl:when test="$var:dice = 'C'">ChannelIslands</xsl:when>
                  <xsl:when test="$var:dice = 'E'">Europe</xsl:when>
                </xsl:choose>
              </xsl:attribute>
            </xsl:if>

            <!--<xsl:if test="DIV_FLG">
              <ns0:OperationalStatus>
                -->
            <!--<xsl:attribute name="CodeContext"></xsl:attribute>-->
            <!--
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOSIndex())" />
                </xsl:attribute>
                <xsl:value-of select="ScriptNS1:GetAIDXCodeContext(DIV_FLG/text(),'Idaho')" />              
              </ns0:OperationalStatus>
              </xsl:if>-->

            <xsl:if test="STATUS">
              <xsl:variable name="var:statusCode" select="ScriptNS1:GetAIDXCode(STATUS/text(), 'Idaho')" />
               <!--<xsl:if test="STATUS/text() != '??' and STATUS/text() != '**'"> </xsl:if>-->
                 
              <xsl:if test="$var:statusCode != 'SYSTEM:IGNORE'">
               
               <ns0:OperationalStatus>
                <xsl:attribute name="CodeContext">
                  <xsl:value-of select="ScriptNS1:GetAIDXCodeContext(STATUS/text(), 'Idaho')" />
                </xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOSIndex())" />
                </xsl:attribute>
                <xsl:value-of select="$var:statusCode" />
              </ns0:OperationalStatus>
                </xsl:if>
               
            </xsl:if>

            <xsl:if test="FLYT_TYPE">
              <ns0:ServiceType>
                <xsl:value-of select="FLYT_TYPE/text()" />
              </ns0:ServiceType>
            </xsl:if>
            <xsl:if test="$var:v24">
              <ns0:PlannedArrivalAptHistory>
                <xsl:if test="DIV_LOC">
                  <xsl:value-of select="DIV_LOC/text()" />
                </xsl:if>
              </ns0:PlannedArrivalAptHistory>
            </xsl:if>
            <xsl:for-each select="DELAYS">
              <xsl:for-each select="DELAYS_ROW">
                <xsl:variable name="var:v26" select="userCSharp:LogicalExistence(boolean(FDDLY1))" />
                <xsl:variable name="var:v28" select="userCSharp:LogicalNot(string($var:v26))" />
                <xsl:variable name="var:v29" select="userCSharp:LogicalExistence(boolean(FDDLY2))" />
                <xsl:variable name="var:v30" select="userCSharp:LogicalAnd(string($var:v28) , string($var:v29))" />
                <ns0:IrregularityDelay>
                  <xsl:attribute name="DepartureOrArrival">
                    <xsl:value-of select="$var:arrdep" />
                  </xsl:attribute>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextDelayIndex())" />
                  </xsl:attribute>
                  <xsl:if test="FDDLY1">
                    <ns0:ReasonCode>
                      <xsl:value-of select="FDDLY1/text()" />
                    </ns0:ReasonCode>
                  </xsl:if>
                  <xsl:if test="string($var:v30)='true'">
                    <xsl:variable name="var:v31" select="FDDLY2/text()" />
                    <ns0:ReasonCode>
                      <xsl:value-of select="$var:v31" />
                    </ns0:ReasonCode>
                  </xsl:if>
                  <xsl:if test="FDDUR">
                    <ns0:Duration>
                      <xsl:value-of select="ScriptNS0:XmlDurationFromIdaho(FDDUR/text())" />
                    </ns0:Duration>
                  </xsl:if>
                  <!--<xsl:value-of select="./text()" />-->
                </ns0:IrregularityDelay>
              </xsl:for-each>
            </xsl:for-each>
            <!--or PAX_UNACC_MINORS or WHEELCHAIR_NO ">-->
            <xsl:if test="SEATS_CLASS1">
              <ns0:CabinClass>
                <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                <xsl:attribute name="Class">F</xsl:attribute>
                <ns0:PaxCount>
                  <xsl:attribute name="Qualifier">70A</xsl:attribute>
                  <xsl:attribute name="Usage">Actual</xsl:attribute>
                  <xsl:attribute name="DestinationType">Local</xsl:attribute>
                  <xsl:value-of select="SEATS_CLASS1/text()" />
                </ns0:PaxCount>
              </ns0:CabinClass>
            </xsl:if>

            <xsl:if test="SEATS_CLASS2">
              <ns0:CabinClass>
                <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                <xsl:attribute name="Class">C</xsl:attribute>

                <ns0:PaxCount>
                  <xsl:attribute name="Qualifier">70A</xsl:attribute>
                  <xsl:attribute name="Usage">Actual</xsl:attribute>
                  <xsl:attribute name="DestinationType">Local</xsl:attribute>
                  <xsl:value-of select="SEATS_CLASS2/text()" />
                </ns0:PaxCount>

              </ns0:CabinClass>
            </xsl:if>

            <xsl:if test="SEATS_CLASS3">
              <ns0:CabinClass>
                <xsl:attribute name="RepeatIndex">3</xsl:attribute>
                <xsl:attribute name="Class">Y</xsl:attribute>

                <ns0:PaxCount>
                  <xsl:attribute name="Qualifier">70A</xsl:attribute>
                  <xsl:attribute name="Usage">Actual</xsl:attribute>
                  <xsl:attribute name="DestinationType">Local</xsl:attribute>
                  <xsl:value-of select="SEATS_CLASS3/text()" />
                </ns0:PaxCount>

              </ns0:CabinClass>
            </xsl:if>

            <xsl:if test="SEATS_CLASS4">
              <ns0:CabinClass>
                <xsl:attribute name="RepeatIndex">4</xsl:attribute>
                <xsl:attribute name="Class">V</xsl:attribute>

                <ns0:PaxCount>
                  <xsl:attribute name="Qualifier">70A</xsl:attribute>
                  <xsl:attribute name="Usage">Actual</xsl:attribute>
                  <xsl:attribute name="DestinationType">Local</xsl:attribute>
                  <xsl:value-of select="SEATS_CLASS4/text()" />
                </ns0:PaxCount>

              </ns0:CabinClass>
            </xsl:if>

            <xsl:if test="PAX_TOTAL or BILL_PAX_TOTAL or PAX_TRANSFER or PAX_TRANSIT or MAX_PAX ">
              <ns0:CabinClass>
                <xsl:attribute name="RepeatIndex">5</xsl:attribute>
                <xsl:choose>
				          <xsl:when test="PAX_TOTAL">
					          <ns0:PaxCount>
						          <xsl:attribute name="Qualifier">70A</xsl:attribute>
						          <xsl:attribute name="Usage">Actual</xsl:attribute>
						          <xsl:attribute name="DestinationType">Local</xsl:attribute>
						          <xsl:value-of select="PAX_TOTAL/text()" />
					          </ns0:PaxCount>
                   </xsl:when>
                   <xsl:otherwise>
					          <xsl:if test="BILL_PAX_TOTAL">
					            <ns0:PaxCount>
						            <xsl:attribute name="Qualifier">70A</xsl:attribute>
						            <xsl:attribute name="Usage">Planned</xsl:attribute>
						            <xsl:attribute name="DestinationType">Local</xsl:attribute>
						            <xsl:value-of select="BILL_PAX_TOTAL/text()" />
					            </ns0:PaxCount>
					          </xsl:if>
				          </xsl:otherwise>
				        </xsl:choose>
                <xsl:if test="PAX_TRANSFER">
                  <ns0:PaxCount>
                    <xsl:attribute name="Qualifier">TPX</xsl:attribute>
                    <xsl:attribute name="Usage">Actual</xsl:attribute>
                    <xsl:attribute name="DestinationType">Local</xsl:attribute>
                    <xsl:value-of select="PAX_TRANSFER/text()" />
                  </ns0:PaxCount>
                </xsl:if>
                <xsl:if test="PAX_TRANSIT">
                  <ns0:PaxCount>
                    <xsl:attribute name="Qualifier">TIP</xsl:attribute>
                    <xsl:attribute name="Usage">Actual</xsl:attribute>
                    <xsl:attribute name="DestinationType">Local</xsl:attribute>
                    <xsl:value-of select="PAX_TRANSIT/text()" />
                  </ns0:PaxCount>
                </xsl:if>
                <xsl:if test="MAX_PAX">
                  <ns0:SeatCapacity>
                    <xsl:value-of select="MAX_PAX/text()" />
                  </ns0:SeatCapacity>
                </xsl:if>
              </ns0:CabinClass>
            </xsl:if>


            <!--<xsl:if test="PAX_TRANSFER or PAX_TRANSIT or PAX_INFANTS ">
              <ns0:CabinClass>
                <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                <xsl:if test="PAX_TRANSIT">
                  -->
            <!--<xsl:attribute name="RepeatIndex">3</xsl:attribute>-->
            <!--
                  <ns0:PaxCount>
                    <xsl:attribute name="Qualifier">TIP</xsl:attribute>
                    <xsl:attribute name="Usage">Actual</xsl:attribute>
                    <xsl:attribute name="DestinationType">Transfer</xsl:attribute>
                    <xsl:value-of select="PAX_TRANSIT/text()" />
                  </ns0:PaxCount>
                </xsl:if>
                <xsl:if test="PAX_TRANSFER">
                  -->
            <!--<xsl:attribute name="RepeatIndex">2</xsl:attribute>-->
            <!--
                  <ns0:PaxCount>
                    <xsl:attribute name="Qualifier">TFP</xsl:attribute>
                    <xsl:attribute name="Usage">Actual</xsl:attribute>
                    <xsl:attribute name="DestinationType">Transfer</xsl:attribute>
                    <xsl:value-of select="PAX_TRANSFER/text()" />
                  </ns0:PaxCount>
                </xsl:if>
                <xsl:if test="PAX_INFANTS">
                  -->
            <!--<xsl:attribute name="RepeatIndex">2</xsl:attribute>-->
            <!--
                  <ns0:PaxCount>
                    <xsl:attribute name="Qualifier">INF</xsl:attribute>
                    <xsl:attribute name="Usage">Actual</xsl:attribute>
                    <xsl:attribute name="DestinationType">Transfer</xsl:attribute>
                    <xsl:value-of select="PAX_INFANTS/text()" />
                  </ns0:PaxCount>
                </xsl:if>

              </ns0:CabinClass>
            </xsl:if>-->


            <xsl:for-each select="FLIGHT_CODE_SHARES">
              <xsl:for-each select="FLIGHT_CODE_SHARES_ROW">
                <xsl:variable name="var:v32" select="position()" />
                <ns0:CodeShareInfo>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="$var:v32" />
                  </xsl:attribute>
                  <ns0:Airline>
                    <xsl:variable name="var:Carrier" select="ScriptNS0:ParseFlightNo(CODE_SHARE_FLYT/text(), 1)"/>
                    <xsl:variable name="var:v33" select="ScriptNS0:GetIataOrIcaoType($var:Carrier)" />
                    <xsl:attribute name="CodeContext">
                      <xsl:value-of select="$var:v33" />
                    </xsl:attribute>
                    <xsl:value-of select="$var:Carrier" />
                  </ns0:Airline>
                  <xsl:if test="CODE_SHARE_FLYT">
                    <ns0:FlightNumber>
                      <xsl:value-of select="ScriptNS0:ParseFlightNo(CODE_SHARE_FLYT/text(), 2)" />
                    </ns0:FlightNumber>
                  </xsl:if>
                  <!--<xsl:value-of select="./text()" />-->
                </ns0:CodeShareInfo>
              </xsl:for-each>
            </xsl:for-each>
            <!--<xsl:for-each select="FLIGHT_CODE_SHARES">
              <xsl:for-each select="FLIGHT_CODE_SHARES_ROW">
                 </xsl:for-each>
            </xsl:for-each>-->
            <xsl:variable name="var:v34" select="position()" />
            <xsl:variable name="var:vArrDep" select="string(ARR_DEP/text())" />
            <xsl:variable name="var:v38" select="userCSharp:LogicalEq($var:vArrDep , &quot;D&quot;)" />
            <xsl:variable name="var:v40" select="userCSharp:LogicalEq($var:vArrDep , &quot;A&quot;)" />

            <xsl:if test="LINKED_FLYT">
              <ns0:AssociatedFlightLegAircraft>
                <!--3055 Code list responsible agency, coded
2 CEC (Commission of the European Communities)
3 IATA (International Air Transport Association)
5 ISO (International Organization of Standardization)
6 IATCI
13 ICAO (International Civil Aviation Organization)
ZZZ Mutually defined-->

                <ns0:Airline>
                  <xsl:attribute name="CodeContext">
                    <xsl:value-of select="ScriptNS0:GetIataOrIcaoType(OP_CODE/text())" />
                  </xsl:attribute>
                  <!--<xsl:value-of select="OP_CODE/text()" />-->
                  <xsl:value-of select="ScriptNS0:ParseFlightNo(LINKED_FLYT/text(), 1)" />
                </ns0:Airline>
                <xsl:if test="FLYT_NO">
                  <ns0:FlightNumber>
                    <!--<xsl:value-of select="$var:flightno" />-->
                    <xsl:value-of select="ScriptNS0:ParseFlightNo(LINKED_FLYT/text(), 2)" />
                  </ns0:FlightNumber>
                </xsl:if>

                <xsl:variable name="var:linkFlightSuffix" select="ScriptNS0:ParseFlightNo(LINKED_FLYT/text(), 3)"/>
                <xsl:if test="$var:linkFlightSuffix != ''">
                  <ns0:OperationalSuffix>
                    <xsl:value-of select="$var:linkFlightSuffix" />
                  </ns0:OperationalSuffix>
                </xsl:if>

                <!--<xsl:if test="QUEBEC">
                <ns0:OperationalSuffix>
                  <xsl:value-of select="QUEBEC/text()" />
                </ns0:OperationalSuffix>
              </xsl:if>-->
                <ns0:DepartureAirport>
                  <xsl:if test="string($var:vArrDep)='A'">LGW</xsl:if>
                  <xsl:if test="string($var:vArrDep)='D'">
                    <xsl:value-of select="Linked_IATALOC_1/text()" />
                  </xsl:if>
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:if test="string($var:vArrDep)='D'">LGW</xsl:if>
                  <xsl:if test="string($var:vArrDep)='A'">
                    <xsl:value-of select="Linked_IATALOC_1/text()" />
                  </xsl:if>
                </ns0:ArrivalAirport>
                <xsl:if test="LINKED_ORIGIN_STO">
                  <ns0:OriginDate>
                    <xsl:value-of select="ScriptNS0:GetXsdDate(string(LINKED_ORIGIN_STO/text()))" />
                  </ns0:OriginDate>
                </xsl:if>
              </ns0:AssociatedFlightLegAircraft>
            </xsl:if>

            <xsl:if test="string($var:vArrDep)='D'">
              <xsl:if test="IATA_LOC1">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="string('LGW')" />
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC2">
                        <xsl:value-of select="IATA_LOC2/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC3">
                        <xsl:value-of select="IATA_LOC3/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC4">
                        <xsl:value-of select="IATA_LOC4/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC5">
                        <xsl:value-of select="IATA_LOC5/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC1">
                        <xsl:value-of select="IATA_LOC1/text()"/>
                      </xsl:when>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>

              <xsl:if test="IATA_LOC2">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC2/text()"/>
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC3">
                        <xsl:value-of select="IATA_LOC3/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC1">
                        <xsl:value-of select="IATA_LOC1/text()"/>
                      </xsl:when>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>

              <xsl:if test="IATA_LOC3">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC3/text()"/>
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC4">
                        <xsl:value-of select="IATA_LOC4/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC1">
                        <xsl:value-of select="IATA_LOC1/text()"/>
                      </xsl:when>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>

              <xsl:if test="IATA_LOC4">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC4/text()"/>
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC5">
                        <xsl:value-of select="IATA_LOC5/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC1">
                        <xsl:value-of select="IATA_LOC1/text()"/>
                      </xsl:when>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>

              <xsl:if test="IATA_LOC5">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC5/text()"/>
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:value-of select="IATA_LOC1/text()"/>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>
            </xsl:if>

            <xsl:if test="string($var:vArrDep)='A'">
              <xsl:if test="IATA_LOC1">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC1/text()" />
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC5">
                        <xsl:value-of select="IATA_LOC5/text()" />
                      </xsl:when>
                      <xsl:when test="IATA_LOC4">
                        <xsl:value-of select="IATA_LOC4/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC3">
                        <xsl:value-of select="IATA_LOC3/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC2">
                        <xsl:value-of select="IATA_LOC2/text()"/>
                      </xsl:when>
                      <xsl:otherwise>LGW</xsl:otherwise>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>

              <xsl:if test="IATA_LOC5">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC5/text()" />
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC4">
                        <xsl:value-of select="IATA_LOC4/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC3">
                        <xsl:value-of select="IATA_LOC3/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC2">
                        <xsl:value-of select="IATA_LOC2/text()"/>
                      </xsl:when>
                      <xsl:otherwise>LGW</xsl:otherwise>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>


              <xsl:if test="IATA_LOC4">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC4/text()" />
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC3">
                        <xsl:value-of select="IATA_LOC3/text()"/>
                      </xsl:when>
                      <xsl:when test="IATA_LOC2">
                        <xsl:value-of select="IATA_LOC2/text()"/>
                      </xsl:when>
                      <xsl:otherwise>LGW</xsl:otherwise>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>


              <xsl:if test="IATA_LOC3">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC3/text()" />
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >
                    <xsl:choose>
                      <xsl:when test="IATA_LOC2">
                        <xsl:value-of select="IATA_LOC2/text()"/>
                      </xsl:when>
                      <xsl:otherwise>LGW</xsl:otherwise>
                    </xsl:choose>
                  </ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>


              <xsl:if test="IATA_LOC2">
                <ns0:AssociatedFlightLegSchedule>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextAFLSIndex())" />
                  </xsl:attribute>
                  <ns0:DepartureAirport>
                    <xsl:attribute name="CodeContext">3</xsl:attribute>
                    <xsl:value-of select="IATA_LOC2/text()" />
                  </ns0:DepartureAirport>
                  <ns0:ArrivalAirport >LGW</ns0:ArrivalAirport>
                </ns0:AssociatedFlightLegSchedule>
              </xsl:if>

            </xsl:if>
            <!--<xsl:if test="IATA_LOC1">
              <ns0:AssociatedFlightLegSchedule>
                <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                <ns0:DepartureAirport>
                  <xsl:value-of select="IATA_LOC1/text()" />
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:value-of select="IATA_LOC1/text()" />
                </ns0:ArrivalAirport>
              </ns0:AssociatedFlightLegSchedule>
            </xsl:if>
            <xsl:if test="IATA_LOC2">
              <ns0:AssociatedFlightLegSchedule>
                <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                <ns0:DepartureAirport>
                  <xsl:value-of select="IATA_LOC2/text()" />
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:value-of select="IATA_LOC2/text()" />
                </ns0:ArrivalAirport>
              </ns0:AssociatedFlightLegSchedule>
            </xsl:if>
            <xsl:if test="IATA_LOC3">
              <ns0:AssociatedFlightLegSchedule>
                <xsl:attribute name="RepeatIndex">3</xsl:attribute>
                <ns0:DepartureAirport>
                  <xsl:value-of select="IATA_LOC3/text()" />
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:value-of select="IATA_LOC3/text()" />
                </ns0:ArrivalAirport>
              </ns0:AssociatedFlightLegSchedule>
            </xsl:if>
            <xsl:if test="IATA_LOC4">
              <ns0:AssociatedFlightLegSchedule>
                <xsl:attribute name="RepeatIndex">4</xsl:attribute>
                <ns0:DepartureAirport>
                  <xsl:value-of select="IATA_LOC4/text()" />
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:value-of select="IATA_LOC4/text()" />
                </ns0:ArrivalAirport>
              </ns0:AssociatedFlightLegSchedule>
            </xsl:if>
            <xsl:if test="IATA_LOC5">
              <ns0:AssociatedFlightLegSchedule>
                <xsl:attribute name="RepeatIndex">5</xsl:attribute>
                <ns0:DepartureAirport>
                  <xsl:value-of select="IATA_LOC5/text()" />
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:value-of select="IATA_LOC5/text()" />
                </ns0:ArrivalAirport>
              </ns0:AssociatedFlightLegSchedule>
            </xsl:if>
            <xsl:if test="IATA_LOC6">
              <ns0:AssociatedFlightLegSchedule>
                <xsl:attribute name="RepeatIndex">6</xsl:attribute>
                <ns0:DepartureAirport>
                  <xsl:value-of select="IATA_LOC6/text()" />
                </ns0:DepartureAirport>
                <ns0:ArrivalAirport>
                  <xsl:value-of select="IATA_LOC6/text()" />
                </ns0:ArrivalAirport>
              </ns0:AssociatedFlightLegSchedule>
            </xsl:if>-->



            <xsl:if test="STATUS/text() = 'GO'">
              <ns0:RemarkTextCode>
                <xsl:attribute name="Qualifier">STF</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextRemarkIndex())" />
                </xsl:attribute>
                <xsl:value-of select="string('GTO')" />
              </ns0:RemarkTextCode>
            </xsl:if>

            <xsl:if test="STATUS/text() = 'BD'">
              <ns0:RemarkTextCode>
                <xsl:attribute name="Qualifier">STF</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextRemarkIndex())" />
                </xsl:attribute>
                <xsl:value-of select="string('BST')" />
              </ns0:RemarkTextCode>
            </xsl:if>

            <xsl:if test="STATUS/text() = 'LC'">
              <ns0:RemarkTextCode>
                <xsl:attribute name="Qualifier">STF</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextRemarkIndex())" />
                </xsl:attribute>
                <xsl:value-of select="string('BEN')" />
              </ns0:RemarkTextCode>
            </xsl:if>

            <xsl:if test="STATUS/text() = 'GC'">
              <ns0:RemarkTextCode>
                <xsl:attribute name="Qualifier">STF</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextRemarkIndex())" />
                </xsl:attribute>
                <xsl:value-of select="string('GCL')" />
              </ns0:RemarkTextCode>
            </xsl:if>

            <!--<xsl:if test="FREE_RMK">
              <ns0:RemarkTextCode>
                <xsl:attribute name="Qualifier">
                  <xsl:value-of select="$var:v44" />
                </xsl:attribute>
                <xsl:attribute name="CodeContext">
                  <xsl:value-of select="$var:v431" />
                </xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextRemarkIndex())" />
                </xsl:attribute>
                <xsl:value-of select="FREE_RMK/text()" />
              </ns0:RemarkTextCode>
            </xsl:if>

            <xsl:if test="IRREG_RMK">
              <ns0:RemarkTextCode>
                <xsl:attribute name="Qualifier">
                  <xsl:value-of select="$var:v44" />
                </xsl:attribute>
                <xsl:attribute name="CodeContext">
                  <xsl:value-of select="$var:v431" />
                </xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextRemarkIndex())" />
                </xsl:attribute>
                <xsl:value-of select="IRREG_RMK/text()" />
              </ns0:RemarkTextCode>
            </xsl:if>-->


            <ns0:AirportResources>
              <xsl:attribute name="Usage">
                <xsl:value-of select="$var:v45" />
              </xsl:attribute>
              <ns0:Resource>
                <xsl:attribute name="DepartureOrArrival">
                  <xsl:value-of select="$var:arrdep" />
                </xsl:attribute>
                <xsl:if test="$var:v51">
                  <xsl:if test="GAPIER">
                    <ns0:AirportZone>
                      <xsl:value-of select="GAPIER/text()" />
                    </ns0:AirportZone>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="$var:v52">
                  <ns0:AircraftParkingPosition>
                    <xsl:attribute name="Qualifier">Other</xsl:attribute>
                    <xsl:value-of select="STND/text()" />
                  </ns0:AircraftParkingPosition>
                </xsl:if>
                <xsl:if test="$var:v53">
                  <ns0:PassengerGate>
                    <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                    <xsl:if test="PUBLIC_GATE">
                      <xsl:value-of select="PUBLIC_GATE/text()" />
                    </xsl:if>
                  </ns0:PassengerGate>
                  <xsl:if test="GATE_NO4">
                    <ns0:RemoteOperationalGate>
                      <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                      <xsl:value-of select="GATE_NO4/text()" />
                    </ns0:RemoteOperationalGate>
                  </xsl:if>
                </xsl:if>

                <xsl:if test="$var:v53 = false">
                  <xsl:if test="GATE_NO4">
                    <ns0:PassengerGate>
                      <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                      <xsl:value-of select="GATE_NO4/text()" />
                    </ns0:PassengerGate>
                  </xsl:if>
                </xsl:if>


                <!--<xsl:if test="SECOND_GATE4">
                  <ns0:PassengerGate>
                    <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                    <xsl:value-of select="SECOND_GATE4/text()" />
                  </ns0:PassengerGate>
                </xsl:if>-->

                <!--<xsl:if test="SECOND_GATE4">
                  <ns0:RemoteOperationalGate>
                    <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                    <xsl:value-of select="SECOND_GATE4/text()" />
                  </ns0:RemoteOperationalGate>
                </xsl:if>-->
                <xsl:if test="RUNWAY">
                  <ns0:Runway>
                    <xsl:value-of select="RUNWAY/text()" />
                  </ns0:Runway>
                </xsl:if>
                <xsl:if test="TERM">
                  <ns0:AircraftTerminal>
                    <xsl:value-of select="TERM/text()" />
                  </ns0:AircraftTerminal>
                </xsl:if>
                <xsl:if test="$var:v57">
                  <ns0:PublicTerminal>
                    <xsl:if test="SECOND_TERM">
                      <xsl:value-of select="SECOND_TERM/text()" />
                    </xsl:if>
                  </ns0:PublicTerminal>
                </xsl:if>
                <xsl:if test="$var:v58">
                  <xsl:if test="CREW_CHANGE_FLG">
                    <ns0:CrewBusInd>
                      <xsl:value-of select="CREW_CHANGE_FLG/text()" />
                    </ns0:CrewBusInd>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="$var:v59">
                  <xsl:if test="COACHED">
                    <ns0:PaxBusInd>
                      <xsl:value-of select="COACHED/text()" />
                    </ns0:PaxBusInd>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="$var:v62">
                  <xsl:if test="CAROUSEL">
                    <ns0:BaggageClaimUnit>
                      <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                      <xsl:value-of select="CAROUSEL/text()" />
                    </ns0:BaggageClaimUnit>
                  </xsl:if>
                  <xsl:if test="CAROUSEL2">
                    <ns0:BaggageClaimUnit>
                      <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                      <xsl:value-of select="CAROUSEL2/text()" />
                    </ns0:BaggageClaimUnit>
                  </xsl:if>
                </xsl:if>
              </ns0:Resource>
            </ns0:AirportResources>

            <xsl:if test="APRON_CHOX_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">OFB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(APRON_CHOX_TM/text()),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="CHOX_TM and string($var:vArrDep)='A'">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">ONB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(CHOX_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="BRD_STA">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">BST</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(BRD_STA/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="PLAN_BD_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">BST</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(PLAN_BD_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="BD_START_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">BST</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">CAL</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(BD_START_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="CTO">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TKO</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">CAL</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(CTO/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="ETO_ARR">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TDN</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ETO_ARR/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="EST_TAKEOFF">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TKO</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(EST_TAKEOFF/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="AIRWAYS_ETO">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">OFB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(AIRWAYS_ETO/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="ETO_DEP">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">OFB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">CAL</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ETO_DEP/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="EST_CHOX">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">ONB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(EST_CHOX/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="EAT_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TEN</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(EAT_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="FINALS">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TEN</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FINALS/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="FIRST_BAG_ACRFT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">FBG</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FIRST_BAG_ACRFT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="GATE_CLSD">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">GCL</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(GATE_CLSD/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="GATE_OPEN">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">GTO</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(GATE_OPEN/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="PLAN_GO_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">GTO</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(PLAN_GO_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="LAST_BAG_ACRFT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">LBG</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(LAST_BAG_ACRFT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="LAST_CALL">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">FCT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(LAST_CALL/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="PLAN_LC_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">FCT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(PLAN_LC_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="NEXT_INFO">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">NEX</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">EST</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(NEXT_INFO/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="string-length(ATO_DEP/text()) > 0">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TKO</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ATO_DEP/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="string-length(ATO_ARR/text()) > 0">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TDN</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ATO_ARR/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="OVERSHOT_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">OVS</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(OVERSHOT_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="RETN_STND_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">RST</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(RETN_STND_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="string-length(STO_DEP/text()) > 0">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">OFB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">SCT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(STO_DEP/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="string-length(STO_ARR/text()) > 0">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">ONB</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">SCT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(STO_ARR/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="SRT">
              <xsl:if test="string($var:vArrDep)='A'">
                <ns0:OperationTime>
                  <xsl:attribute name="OperationQualifier">TDN</xsl:attribute>
                  <xsl:attribute name="CodeContext">9750</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                  </xsl:attribute>
                  <xsl:attribute name="TimeType">SCT</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(SRT/text(),'Z')"/>
                </ns0:OperationTime>
              </xsl:if>
              <xsl:if test="string($var:vArrDep)='D'">
                <ns0:OperationTime>
                  <xsl:attribute name="OperationQualifier">TKO</xsl:attribute>
                  <xsl:attribute name="CodeContext">9750</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">
                    <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                  </xsl:attribute>
                  <xsl:attribute name="TimeType">SCT</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(SRT/text(),'Z')"/>
                </ns0:OperationTime>
              </xsl:if>
            </xsl:if>
            <xsl:if test="TLDT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TDN</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">TAR</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(TLDT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>

            <xsl:if test="TTOT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">TKO</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">TAR</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(TTOT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="OPT_TTOT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">OTT</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">TAR</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(OPT_TTOT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="APP_DEP_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">SAT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">TAR</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(APP_DEP_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="OPT_TSAT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">SAT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">CAL</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(OPT_TSAT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="ZONED_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">THM</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ZONED_TM/text(),'Z')"/>
              </ns0:OperationTime>
              <!--<ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">ALR</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ZONED_TM/text(),'Z')"/>
              </ns0:OperationTime>-->
            </xsl:if>
            <xsl:if test="ENG_REQ_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">SRT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ENG_REQ_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="ENG_STA_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">SAT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ENG_STA_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="SEGS_ARMED">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">SEG</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(SEGS_ARMED/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="GROUND_HAND_START_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">CGT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(GROUND_HAND_START_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="GROUND_HAND_END_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">AEG</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(GROUND_HAND_END_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="DOORS_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">DCL</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(DOORS_TM/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="ARDT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">RDT</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ARDT/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="LPOC_ATO">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">ATO</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(LPOC_ATO/text(),'Z')"/>
              </ns0:OperationTime>
            </xsl:if>
            <!--<xsl:if test="CABIN_RELEASED">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">DOP</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(CABIN_RELEASED/text())"></xsl:value-of>
              </ns0:OperationTime>
            </xsl:if>-->
            <xsl:if test="LAST_PAX_ACRFT">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">LPO</xsl:attribute>
                <xsl:attribute name="CodeContext">0000</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(LAST_PAX_ACRFT/text())"/>
              </ns0:OperationTime>
            </xsl:if>

            <xsl:if test="RUNWAY_HOLD_ENTRY_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">HST</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(RUNWAY_HOLD_ENTRY_TM/text())"/>
              </ns0:OperationTime>
            </xsl:if>
            <xsl:if test="RUNWAY_HOLD_EXIT_TM">
              <ns0:OperationTime>
                <xsl:attribute name="OperationQualifier">HEN</xsl:attribute>
                <xsl:attribute name="CodeContext">9750</xsl:attribute>
                <xsl:attribute name="RepeatIndex">
                  <xsl:value-of select="string(userCSharp:GetNextOpTimeIndex())" />
                </xsl:attribute>
                <xsl:attribute name="TimeType">ACT</xsl:attribute>
                <xsl:value-of select="ScriptNS0:FormatOracleDateTime(RUNWAY_HOLD_EXIT_TM/text())"/>
              </ns0:OperationTime>
            </xsl:if>

            <ns0:AircraftInfo>
              <xsl:if test="ACRFT_TYPE">
                <ns0:AircraftType>
                  <xsl:value-of select="ACRFT_TYPE/text()" />
                </ns0:AircraftType>
              </xsl:if>
              <xsl:if test="REG">
                <ns0:Registration>
                  <xsl:value-of select="REG/text()" />
                </ns0:Registration>
              </xsl:if>

              <xsl:if test="HA1">
                <ns0:AgentInfo>
                  <xsl:attribute name="DepartureOrArrival">
                    <xsl:value-of select="$var:arrdep" />
                  </xsl:attribute>
                  <xsl:attribute name="Qualifier">AGT</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">1</xsl:attribute>
                  <xsl:value-of select="HA1/text()" />
                </ns0:AgentInfo>
              </xsl:if>

              <xsl:if test="HA2">
                <ns0:AgentInfo>
                  <xsl:attribute name="DepartureOrArrival">
                    <xsl:value-of select="$var:arrdep" />
                  </xsl:attribute>
                  <xsl:attribute name="Qualifier">AGT</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">2</xsl:attribute>
                  <xsl:value-of select="HA2/text()" />
                </ns0:AgentInfo>
              </xsl:if>
              <xsl:if test="HA3">
                <ns0:AgentInfo>
                  <xsl:attribute name="DepartureOrArrival">
                    <xsl:value-of select="$var:arrdep" />
                  </xsl:attribute>
                  <xsl:attribute name="Qualifier">AGT</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">3</xsl:attribute>
                  <xsl:value-of select="HA3/text()" />
                </ns0:AgentInfo>
              </xsl:if>
              <xsl:if test="HA4">
                <ns0:AgentInfo>
                  <xsl:attribute name="DepartureOrArrival">
                    <xsl:value-of select="$var:arrdep" />
                  </xsl:attribute>
                  <xsl:attribute name="Qualifier">AGT</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">4</xsl:attribute>
                  <xsl:value-of select="HA4/text()" />
                </ns0:AgentInfo>
              </xsl:if>
              <xsl:if test="HA5">
                <ns0:AgentInfo>
                  <xsl:attribute name="DepartureOrArrival">
                    <xsl:value-of select="$var:arrdep" />
                  </xsl:attribute>
                  <xsl:attribute name="Qualifier">AGT</xsl:attribute>
                  <xsl:attribute name="RepeatIndex">5</xsl:attribute>
                  <xsl:value-of select="HA5/text()" />
                </ns0:AgentInfo>
              </xsl:if>
              <xsl:if test="ATC_CALL_SIGN">
                <ns0:CallSign>
                  <xsl:value-of select="ATC_CALL_SIGN/text()" />
                </ns0:CallSign>
              </xsl:if>
              <xsl:if test="FRT_WGHT">
                <ns0:DeadLoad>
                  <!--xsl:attribute name="DestinationType"></xsl:attribute-->
                  <ns0:Type>C</ns0:Type>
                  <ns0:Weight>
                    <xsl:attribute name="MeasurementUnit">Kilogram</xsl:attribute>
                    <xsl:value-of select="FRT_WGHT/text()" />
                  </ns0:Weight>
                </ns0:DeadLoad>
              </xsl:if>

              <xsl:if test="MAIL_WGHT">
                <ns0:DeadLoad>
                  <ns0:Type>M</ns0:Type>
                  <ns0:Weight>
                    <xsl:attribute name="MeasurementUnit">Kilogram</xsl:attribute>
                    <xsl:value-of select="MAIL_WGHT/text()" />
                  </ns0:Weight>
                </ns0:DeadLoad>
              </xsl:if>


              <xsl:if test="BAG_WGHT">
                <ns0:Baggage>
                  <ns0:Weight>
                    <xsl:attribute name="MeasurementUnit">Kilogram</xsl:attribute>
                    <xsl:if test="BAG_WGHT">
                      <xsl:value-of select="BAG_WGHT/text()" />
                    </xsl:if>
                  </ns0:Weight>
                </ns0:Baggage>
              </xsl:if>



            </ns0:AircraftInfo>
            <ns0:PublicFlightDisplay>
              <ns0:AirlineType>
                <!--<xsl:variable name="var:v682" select="ScriptNS0:GetIataOrIcaoType($var:v681)" />
                <xsl:attribute name="CodeContext">
                  <xsl:value-of select="$var:v682" />
                </xsl:attribute>-->
                <xsl:value-of select="OP_CODE/text()" />
              </ns0:AirlineType>
              <ns0:FlightNumber>
                <xsl:value-of select="$var:flightno" />
              </ns0:FlightNumber>

            </ns0:PublicFlightDisplay>
          </ns0:LegData>
          <ns0:TPA_Extension>
            <ns2:ControlData>
              <xsl:attribute name="DataOperationType">Amend</xsl:attribute>
              <xsl:if test="BAGS_ACTIVE">
                <ns2:FIDSBagggeHallActive>
                  <xsl:value-of select="BAGS_ACTIVE/text()" />
                </ns2:FIDSBagggeHallActive>
              </xsl:if>
              <xsl:if test="BAGS_ROLL_OFF_TM">
                <ns2:FIDSBaggageRollOffDateTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(BAGS_ROLL_OFF_TM/text(),'Z')"/>
                </ns2:FIDSBaggageRollOffDateTime>
              </xsl:if>
              <xsl:if test="BAGS_ROLL_ON_TM">
                <ns2:FIDSBaggageRollOnDateTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(BAGS_ROLL_ON_TM/text(),'Z')"/>
                </ns2:FIDSBaggageRollOnDateTime>
              </xsl:if>
              <xsl:if test="FIDS_ACTIVE">
                <ns2:FIDSFlightActive>
                  <xsl:value-of select="FIDS_ACTIVE/text()" />
                </ns2:FIDSFlightActive>
              </xsl:if>
              <xsl:if test="FIDS_ROLL_OFF_TM">
                <ns2:FIDSRollOffDateTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FIDS_ROLL_OFF_TM/text(),'Z')"/>
                </ns2:FIDSRollOffDateTime>
              </xsl:if>
              <xsl:if test="FIDS_ROLL_ON_TM">
                <ns2:FIDSRollOnDatetime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FIDS_ROLL_ON_TM/text(),'Z')"/>
                </ns2:FIDSRollOnDatetime>
              </xsl:if>
              <ns2:FIDSOperationType>A</ns2:FIDSOperationType>

              <xsl:if test="CHKIN_CLSD">
                <ns2:CheckInClosedTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(CHKIN_CLSD/text(),'Z')"/>
                </ns2:CheckInClosedTime>
              </xsl:if>
              <xsl:if test="CHKIN_OPEN">
                <ns2:CheckInOpenTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(CHKIN_OPEN/text(),'Z')"/>
                </ns2:CheckInOpenTime>
              </xsl:if>
              <xsl:if test="CHKIN_ZONE">
                <ns2:CheckInZone>
                  <xsl:value-of select="CHKIN_ZONE/text()"/>
                </ns2:CheckInZone>
              </xsl:if>
              <xsl:if test="CHKIN_INFO">
                <ns2:CheckInZoneInfo>
                  <xsl:value-of select="CHKIN_INFO/text()"/>
                </ns2:CheckInZoneInfo>
              </xsl:if>
              <xsl:if test="DISABLE_GT">
                <ns2:DisableGateTimingRulesflag>
                  <xsl:value-of select="DISABLE_GT/text()"/>
                </ns2:DisableGateTimingRulesflag>
              </xsl:if>
              <xsl:if test="DISP_TM">
                <ns2:DisplayTime>
                  <xsl:value-of select="ScriptNS0:SplitTime(DISP_TM/text())"/>
                </ns2:DisplayTime>
              </xsl:if>
              <xsl:if test="FIDS_CODE">
                <ns2:FIDSAnnouncementCode>
                  <xsl:value-of select="FIDS_CODE/text()"/>
                </ns2:FIDSAnnouncementCode>
              </xsl:if>
              <xsl:if test="CX_FIDS_DISP">
                <ns2:FIDSCancelDisplayFlag>
                  <xsl:value-of select="CX_FIDS_DISP/text()"/>
                </ns2:FIDSCancelDisplayFlag>
              </xsl:if>
              <xsl:if test="FIDS_CHKIN_ZONE">
                <ns2:FIDSCheckInZone>
                  <xsl:value-of select="FIDS_CHKIN_ZONE/text()"/>
                </ns2:FIDSCheckInZone>
              </xsl:if>
              <xsl:if test="CONDITION_CODE">
                <ns2:FIDSConditionCode>
                  <xsl:value-of select="CONDITION_CODE/text()"/>
                </ns2:FIDSConditionCode>
              </xsl:if>
              <xsl:if test="INHIBIT_VIDEO">
                <ns2:FIDSInhibitOutputToVideo>
                  <xsl:value-of select="INHIBIT_VIDEO/text()"/>
                </ns2:FIDSInhibitOutputToVideo>
              </xsl:if>
              <xsl:if test="INHIBIT_FIDS">
                <ns2:FIDSInhibitTimedEventsFlag>
                  <xsl:value-of select="INHIBIT_FIDS/text()"/>
                </ns2:FIDSInhibitTimedEventsFlag>
              </xsl:if>
              <xsl:if test="INHIBIT_DELTAS">
                <ns2:FIDSInhibitTimeDeltasFlag>
                  <xsl:value-of select="INHIBIT_DELTAS/text()"/>
                </ns2:FIDSInhibitTimeDeltasFlag>
              </xsl:if>
              <xsl:if test="PRIORITY_DISP">
                <ns2:FIDSPriorityFlightDisplayFlag>
                  <xsl:value-of select="PRIORITY_DISP/text()"/>
                </ns2:FIDSPriorityFlightDisplayFlag>
              </xsl:if>
            </ns2:ControlData>

            <xsl:variable name="var:useStack" select="normalize-space(STACK/text())"/>

            <xsl:if test="$var:useStack != '' ">
              <ns2:HoldingDurationData>

                <ns2:SectorIdentification>
                  <xsl:value-of select="STACK/text()"/>
                </ns2:SectorIdentification>


                <xsl:if test="STACK_ENTRY_TM">
                  <ns2:MovementArrivalSectorTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(STACK_ENTRY_TM/text())"/>
                  </ns2:MovementArrivalSectorTime>
                </xsl:if>

                <xsl:if test="STACK_EXIT_TM">
                  <ns2:MovementExitSectorTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(STACK_EXIT_TM/text())"/>
                  </ns2:MovementExitSectorTime>
                </xsl:if>

                <xsl:if test="STACK_DELAY">
                  <ns2:MovementHoldingDelay>
                    <xsl:value-of select="STACK_DELAY/text()"/>
                  </ns2:MovementHoldingDelay>
                </xsl:if>

                <xsl:if test="RUNWAY">
                  <ns2:ExpectedFacilityIdentification>
                    <xsl:value-of select="RUNWAY/text()"/>
                  </ns2:ExpectedFacilityIdentification>
                </xsl:if>
              </ns2:HoldingDurationData>
            </xsl:if>

            <xsl:if test="$var:useStack = '' and contains(AGENCY_RMK/text(),'STACK:')">
              <ns2:HoldingDurationData>
                <xsl:variable name="var:agencyRemark" select="normalize-space(AGENCY_RMK/text())"/>
                <ns2:SectorIdentification>
                  <xsl:value-of select="substring-after(substring-before($var:agencyRemark,' ETA:'),'STACK:')"/>
                </ns2:SectorIdentification>
                <ns2:MovementArrivalSectorTime>
                  <xsl:value-of select="ScriptNS0:GetXsdTime(substring-after(substring-before($var:agencyRemark,' EAT:'),'ETA:'))"/>
                </ns2:MovementArrivalSectorTime>
                <ns2:MovementExitSectorTime>
                  <xsl:value-of select="ScriptNS0:GetXsdTime(substring-after(substring-before($var:agencyRemark,' DELAY:'),'EAT:'))"/>
                </ns2:MovementExitSectorTime>
                <xsl:variable name="var:holdingDelay" select="substring-after(substring-before($var:agencyRemark,' RWY:'),'DELAY:')"/>
                <xsl:if test="$var:holdingDelay != '' and $var:holdingDelay != '0'">
                  <ns2:MovementHoldingDelay>
                    <xsl:value-of select="$var:holdingDelay"/>
                  </ns2:MovementHoldingDelay>
                </xsl:if>
                <ns2:ExpectedFacilityIdentification>
                  <xsl:value-of select="substring-after(AGENCY_RMK/text(),'RWY:')"/>
                </ns2:ExpectedFacilityIdentification>
              </ns2:HoldingDurationData>
            </xsl:if>

            <xsl:variable name="var:standLogRows" select="count(STAND_LOG/STAND_LOG_ROW)" />
            <xsl:variable name="var:plannedStandLogRows" select="count(PLANNED_STAND_LOG/PLANNED_STAND_LOG_ROW)" />

            <xsl:if test="$var:standLogRows > 0 or $var:plannedStandLogRows > 0">

              <ns2:GroundMovementData>
                <xsl:for-each select="STAND_LOG">
                  <xsl:for-each select="STAND_LOG_ROW">
                    <ns2:GroundMovement>
                      <xsl:if test="SAPORA">
                        <xsl:attribute name="GroundMovementStatus">
                          <xsl:choose>
                            <xsl:when test="SAPORA/text() = '0'">Provisional</xsl:when>
                            <xsl:otherwise>Confirmed</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </xsl:if>
                      <xsl:if test="SADESC">
                        <xsl:attribute name="GroundMovementType">
                          <xsl:value-of select="SADESC/text()" />
                        </xsl:attribute>
                      </xsl:if>
                      <!--<ns2:GroundMovementFromStand>TODO</ns2:GroundMovementFromStand>-->
                      <xsl:if test="SARQTM">
                        <!--<ns2:GroundMovementOffDateTime>
                            <xsl:value-of select="ScriptNS0:FormatOracleDateTime(SARQTM/text(),'Z')"></xsl:value-of>
                          </ns2:GroundMovementOffDateTime>-->
                        <ns2:GroundMovementOnDateTime>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(SARQTM/text(),'Z')"/>
                        </ns2:GroundMovementOnDateTime>
                      </xsl:if>
                      <xsl:if test="SASTND">
                        <ns2:GroundMovementToStand>
                          <xsl:value-of select="SASTND/text()" />
                        </ns2:GroundMovementToStand>
                      </xsl:if>
                      <ns2:GroundMovementUniqueID>
                        <xsl:value-of select="SARECN/text()" />
                      </ns2:GroundMovementUniqueID>
                      <ns2:DataOperationType>
                        <xsl:choose>
                          <xsl:when test="SADEFLG">
                            <xsl:value-of select="SADEFLG/text()" />
                          </xsl:when>
                          <xsl:otherwise>A</xsl:otherwise>
                        </xsl:choose>
                      </ns2:DataOperationType>

                      <xsl:if test="SAPGNM">
                        <ns2:AppUsed>
                          <xsl:value-of select="SAPGNM/text()" />
                        </ns2:AppUsed>
                      </xsl:if>
                      <xsl:if test="SADEPT">
                        <ns2:Department>
                          <xsl:value-of select="SADEPT/text()" />
                        </ns2:Department>
                      </xsl:if>
                      <xsl:if test="SAFLID">
                        <ns2:FlightID>
                          <xsl:value-of select="SAFLID/text()" />
                        </ns2:FlightID>
                      </xsl:if>
                      <xsl:if test="SALUSR">
                        <ns2:LastUser>
                          <xsl:value-of select="SALUSR/text()" />
                        </ns2:LastUser>
                      </xsl:if>
                      <xsl:if test="SAFMC">
                        <ns2:LogFormat>
                          <xsl:value-of select="SAFMC/text()" />
                        </ns2:LogFormat>
                      </xsl:if>
                      <xsl:if test="SALGTM">
                        <ns2:LogTime>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(SALGTM/text(),'Z')"/>
                        </ns2:LogTime>
                      </xsl:if>
                      <xsl:if test="SAONOF">
                        <ns2:OnOff>
                          <xsl:value-of select="SAONOF/text()" />
                        </ns2:OnOff>
                      </xsl:if>
                      <xsl:if test="SAPINW">
                        <ns2:ParkedInToWind>
                          <xsl:value-of select="SAPINW/text()" />
                        </ns2:ParkedInToWind>
                      </xsl:if>
                      <xsl:if test="SASIDE">
                        <ns2:ParkedSide>
                          <xsl:value-of select="SASIDE/text()" />
                        </ns2:ParkedSide>
                      </xsl:if>
                      <xsl:if test="SARMKS">
                        <ns2:Remarks>
                          <xsl:value-of select="SARMKS/text()" />
                        </ns2:Remarks>
                      </xsl:if>
                      <xsl:if test="SAWSID">
                        <ns2:WSID>
                          <xsl:value-of select="SAWSID/text()" />
                        </ns2:WSID>
                      </xsl:if>
                    </ns2:GroundMovement>
                  </xsl:for-each>
                </xsl:for-each>



                <xsl:for-each select="PLANNED_STAND_LOG">
                  <xsl:for-each select="PLANNED_STAND_LOG_ROW">
                    <ns2:PlannedGroundMovement>
                      <xsl:if test="ACT_END_TM">
                        <ns2:ActualEndTime>

                        </ns2:ActualEndTime>
                      </xsl:if>
                      <xsl:if test="ACT_START_TM">
                        <ns2:ActualStartTime>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ACT_START_TM/text(),'Z')"/>
                        </ns2:ActualStartTime>
                      </xsl:if>
                      <xsl:if test="REG">
                        <ns2:AircraftRegistration>
                          <xsl:value-of select="REG/text()" />
                        </ns2:AircraftRegistration>
                      </xsl:if>
                      <xsl:if test="EXTERNAL_REF ">
                        <ns2:ExternalRef>
                          <xsl:value-of select="EXTERNAL_REF /text()" />
                        </ns2:ExternalRef>
                      </xsl:if>
                      <xsl:if test="ARR_REC_NO ">
                        <ns2:FlightNumber>
                          <xsl:value-of select="ARR_REC_NO /text()" />
                        </ns2:FlightNumber>
                      </xsl:if>
                      <xsl:if test="FROM_STAND">
                        <ns2:FromStand>
                          <xsl:value-of select="FROM_STAND/text()" />
                        </ns2:FromStand>
                      </xsl:if>
                      <xsl:if test="HOLD_IND">
                        <ns2:HoldIndicator>
                          <xsl:value-of select="HOLD_IND/text()" />
                        </ns2:HoldIndicator>
                      </xsl:if>
                      <xsl:if test="PENDING">
                        <ns2:Pending>
                          <xsl:value-of select="PENDING/text()" />
                        </ns2:Pending>
                      </xsl:if>
                      <xsl:if test="PLAN_END_TM">
                        <ns2:PlannedEndTime>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(PLAN_END_TM/text(),'Z')"/>
                        </ns2:PlannedEndTime>
                      </xsl:if>
                      <xsl:if test="PLAN_START_TM">
                        <ns2:PlannedStartTime>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(PLAN_START_TM/text(),'Z')"/>
                        </ns2:PlannedStartTime>
                      </xsl:if>
                      <xsl:if test="MOVE_POWER">
                        <ns2:Powered>
                          <xsl:value-of select="MOVE_POWER/text()" />
                        </ns2:Powered>
                      </xsl:if>
                      <xsl:if test="MOVE_SEQNO">
                        <ns2:SequenceNumber>
                          <xsl:value-of select="MOVE_SEQNO/text()" />
                        </ns2:SequenceNumber>
                      </xsl:if>
                      <xsl:if test="TO_STAND">
                        <ns2:ToStand>
                          <xsl:value-of select="TO_STAND/text()" />
                        </ns2:ToStand>
                      </xsl:if>
                      <xsl:if test="UPDT_AT">
                        <ns2:UpdatedAt>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(UPDT_AT/text(),'Z')"/>
                        </ns2:UpdatedAt>
                      </xsl:if>
                      <xsl:if test="UPDT_BY">
                        <ns2:UpdatedBy>
                          <xsl:value-of select="UPDT_BY/text()" />
                        </ns2:UpdatedBy>
                      </xsl:if>

                    </ns2:PlannedGroundMovement>
                  </xsl:for-each>
                </xsl:for-each>


              </ns2:GroundMovementData>
            </xsl:if>



            <xsl:if test="SPACING_REQ_MILES or SPACING_REQ_SECONDS or SPACING_AT4_MILES or SPACING_ALDT_MILES or SPACING_CC_MILES or SPACING_AT4_SECONDS or SPACING_ALDT_SECONDS or SPACING_CC_SECONDS">
              <ns2:AtcSpacingData>
                <xsl:if test="SPACING_REQ_MILES">
                  <ns2:RequestedArrivalsSpacingNM>
                    <xsl:value-of select="SPACING_REQ_MILES/text()" />
                  </ns2:RequestedArrivalsSpacingNM>
                </xsl:if>
                <xsl:if test="SPACING_REQ_SECONDS">
                  <ns2:RequestedArrivalsSpacingSeconds>
                    <xsl:value-of select="SPACING_REQ_SECONDS/text()" />
                  </ns2:RequestedArrivalsSpacingSeconds>
                </xsl:if>
                <xsl:if test="SPACING_AT4_MILES">
                  <ns2:ActualArrivalsSpacing4DME_NW>
                    <xsl:value-of select="SPACING_AT4_MILES/text()" />
                  </ns2:ActualArrivalsSpacing4DME_NW>
                </xsl:if>
                <xsl:if test="SPACING_ALDT_MILES">
                  <ns2:ActualArrivalsSpacingALDT_NW>
                    <xsl:value-of select="SPACING_ALDT_MILES/text()" />
                  </ns2:ActualArrivalsSpacingALDT_NW>
                </xsl:if>
                <xsl:if test="SPACING_CC_MILES">
                  <ns2:ActualArrivalsSpacingCrossConcrete_NW>
                    <xsl:value-of select="SPACING_CC_MILES/text()" />
                  </ns2:ActualArrivalsSpacingCrossConcrete_NW>
                </xsl:if>
                <xsl:if test="SPACING_AT4_SECONDS">
                  <ns2:ActualArrivalsSpacing4DME_Seconds>
                    <xsl:value-of select="SPACING_AT4_SECONDS/text()" />
                  </ns2:ActualArrivalsSpacing4DME_Seconds>
                </xsl:if>
                <xsl:if test="SPACING_ALDT_SECONDS">
                  <ns2:ActualArrivalsSpacingALDT_Seconds>
                    <xsl:value-of select="SPACING_ALDT_SECONDS/text()" />
                  </ns2:ActualArrivalsSpacingALDT_Seconds>
                </xsl:if>
                <xsl:if test="SPACING_CC_SECONDS">
                  <ns2:ActualArrivalsSpacingCrossConcrete_Seconds>
                    <xsl:value-of select="SPACING_CC_SECONDS/text()" />
                  </ns2:ActualArrivalsSpacingCrossConcrete_Seconds>
                </xsl:if>
              </ns2:AtcSpacingData>
            </xsl:if>
            <ns2:FlightLegExtension>
              <xsl:if test="REC_NO">
                <ns2:AODBUniqueField>
                  <xsl:value-of select="REC_NO/text()" />
                </ns2:AODBUniqueField>
              </xsl:if>
              <xsl:if test="EFPS_IFPLID">
                <ns2:ATCFlightPlanID>
                  <xsl:value-of select="EFPS_IFPLID/text()" />
                </ns2:ATCFlightPlanID>
              </xsl:if>
              <xsl:if test="IFPLID">
                <ns2:FlightPlanID>
                  <xsl:value-of select="IFPLID/text()" />
                </ns2:FlightPlanID>
              </xsl:if>
              <xsl:if test="ATC_FLYT_NO">
                <ns2:ATCFlightNumber>
                  <xsl:value-of select="ATC_FLYT_NO/text()" />
                </ns2:ATCFlightNumber>
              </xsl:if>
              <xsl:if test="ATC_OP">
                <ns2:ATCOperator>
                  <xsl:value-of select="ATC_FLYT_NO/text()" />
                </ns2:ATCOperator>
              </xsl:if>
              <xsl:if test="DIV_FLG">
                <ns2:OperationalStatus Qualifier="DIV" RepeatIndex="1">
                  <xsl:value-of select="DIV_FLG/text()"/>
                </ns2:OperationalStatus>
              </xsl:if>
              <xsl:if test="GATE_STATUS">
                <ns2:OperationalStatus Qualifier="GBS" RepeatIndex="2">
                  <xsl:value-of select="GATE_STATUS/text()" />
                </ns2:OperationalStatus>
              </xsl:if>
              <xsl:if test="APRON_RMK">
                <ns2:Remark Qualifier="APR" RepeatIndex="1">
                  <xsl:value-of select="APRON_RMK/text()" />
                </ns2:Remark>
              </xsl:if>
              <xsl:if test="AGENCY_RMK">
                <ns2:Remark Qualifier="AGY" RepeatIndex="2">
                  <xsl:value-of select="AGENCY_RMK/text()" />
                </ns2:Remark>
              </xsl:if>
              <xsl:if test="GENERAL_RMK">
                <ns2:Remark Qualifier="GEN" RepeatIndex="3">
                  <xsl:value-of select="GENERAL_RMK/text()" />
                </ns2:Remark>
              </xsl:if>
              <xsl:if test="HA_RMK">
                <ns2:Remark Qualifier="HAR" RepeatIndex="4">
                  <xsl:value-of select="HA_RMK/text()" />
                </ns2:Remark>
              </xsl:if>
              <xsl:if test="FREE_RMK">
                <ns2:Remark Qualifier="FRE" RepeatIndex="5">
                  <xsl:value-of select="FREE_RMK/text()" />
                </ns2:Remark>
              </xsl:if>
              <ns2:AirlineData>
                <xsl:if test="IATA_FLYT_NO">
                  <ns2:AirlineIATA>
                    <xsl:value-of select="substring(IATA_FLYT_NO/text(),1, 2)" />
                  </ns2:AirlineIATA>
                </xsl:if>
                <xsl:if test="ICAO_FLYT_NO">
                  <ns2:AirlineICAO>
                    <xsl:value-of select="substring(ICAO_FLYT_NO/text(),1, 3)" />
                  </ns2:AirlineICAO>
                </xsl:if>
                <xsl:if test="DMAN_PRIORITY">
                  <ns2:AirlinePriorityFlag>
                    <xsl:value-of select="DMAN_PRIORITY/text()" />
                  </ns2:AirlinePriorityFlag>
                </xsl:if>
                <xsl:if test="ETTT">
                  <ns2:ETTT>
                    <xsl:value-of select="ETTT/text()" />
                  </ns2:ETTT>
                </xsl:if>
                <xsl:if test="MIN_TURN_TIME">
                  <ns2:MTTT>
                    <xsl:value-of select="MIN_TURN_TIME/text()" />
                  </ns2:MTTT>
                </xsl:if>
                <xsl:if test="LINKED_STO and STO">
                  <ns2:STTT>
                    <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(LINKED_STO/text()),string(STO/text()))"/>
                  </ns2:STTT>
                </xsl:if>
                <xsl:if test="IATA_FLYT_NO">
                  <ns2:IATAFlightNumber>
                    <xsl:value-of select="IATA_FLYT_NO/text()" />
                  </ns2:IATAFlightNumber>
                </xsl:if>
              </ns2:AirlineData>
              <ns2:AircraftData>
                <xsl:if test="ACRFT_TYPE_ICAO">
                  <ns2:AircraftTypeICAO>
                    <xsl:value-of select="ACRFT_TYPE_ICAO/text()" />
                  </ns2:AircraftTypeICAO>
                </xsl:if>
                <xsl:if test="ACWAKE">
                  <ns2:WakeVortexClassification>
                    <xsl:value-of select="ACWAKE/text()" />
                  </ns2:WakeVortexClassification>
                </xsl:if>
                <xsl:if test="SID">
                  <ns2:StandardInstrumentDeparture>
                    <xsl:value-of select="SID/text()" />
                  </ns2:StandardInstrumentDeparture>
                </xsl:if>
                <xsl:if test="MIN_INTERVAL">
                  <ns2:MinimumDepartureIntervalForFlight>
                    <xsl:value-of select="MIN_INTERVAL/text()" />
                  </ns2:MinimumDepartureIntervalForFlight>
                </xsl:if>
                <xsl:if test="ICAO_FLYT_NO">
                  <ns2:FlightTypeIdentifierICAO>
                    <xsl:value-of select="ICAO_FLYT_NO/text()" />
                  </ns2:FlightTypeIdentifierICAO>
                </xsl:if>
                <xsl:if test="USR_REG">
                  <ns2:AircraftRegistrationUser>
                    <xsl:value-of select="USR_REG/text()" />
                  </ns2:AircraftRegistrationUser>
                </xsl:if>
                <xsl:if test="ACRFT_VERSION">
                  <ns2:AircraftVersion>
                    <xsl:value-of select="ACRFT_VERSION/text()" />
                  </ns2:AircraftVersion>
                </xsl:if>
                <xsl:if test="NO_OF_BARS">
                  <ns2:NumberOfBars>
                    <xsl:value-of select="NO_OF_BARS/text()" />
                  </ns2:NumberOfBars>
                </xsl:if>
              </ns2:AircraftData>
              <ns2:ResourceData>
                <xsl:if test="HOLD_IND">
                  <ns2:ArrivalStandHoldIsRequired>
                    <xsl:value-of select="HOLD_IND/text()" />
                  </ns2:ArrivalStandHoldIsRequired>
                  <ns2:ArrivalStandHoldType>
                    <xsl:choose>
                      <xsl:when test="HOLD_IND/text() = 'X' or HOLD_IND/text() = '*'">Cleared</xsl:when>
                      <xsl:when test="HOLD_IND/text() = 'H'">Standard</xsl:when>
                      <xsl:when test="HOLD_IND/text() = 'A(Manual)'">Manual</xsl:when>
                      <xsl:when test="HOLD_IND/text() = 'A(Not Manual)'">Adjacency</xsl:when>
                    </xsl:choose>
                  </ns2:ArrivalStandHoldType>
                </xsl:if>
                <xsl:if test="CONFLICTING_STAND">
                  <ns2:ArrivalStandHoldConflictingStand>
                    <xsl:value-of select="CONFLICTING_STAND/text()" />
                  </ns2:ArrivalStandHoldConflictingStand>
                </xsl:if>
                <xsl:if test="MARSHALLING">
                  <ns2:MarshallingIsRequired>
                    <xsl:value-of select="MARSHALLING/text()" />
                  </ns2:MarshallingIsRequired>
                </xsl:if>
                <xsl:if test="B_AND_F_POSTED">
                  <ns2:StandChangesCount>
                    <xsl:value-of select="B_AND_F_POSTED/text()" />
                  </ns2:StandChangesCount>
                </xsl:if>
                <ns2:EstimatedROT>TODO</ns2:EstimatedROT>
                <xsl:if test="VTT">
                  <ns2:EXIT>
                    <xsl:value-of select="VTT/text()" />
                  </ns2:EXIT>
                </xsl:if>
                <xsl:if test="EXOT">
                  <ns2:EXOT>
                    <xsl:value-of select="EXOT/text()" />
                  </ns2:EXOT>
                </xsl:if>
                <ns2:ZonedTimeToRunway>TODO</ns2:ZonedTimeToRunway>
                <ns2:FinalTimeToRunway>TODO</ns2:FinalTimeToRunway>
                <ns2:PreviousGate>TODO</ns2:PreviousGate>
                <xsl:if test="SELECT_TYPE">
                  <ns2:GateBoardingMethod>
                    <xsl:value-of select="SELECT_TYPE/text()" />
                  </ns2:GateBoardingMethod>
                </xsl:if>
                <xsl:if test="GATE_TYPE">
                  <ns2:GateType>
                    <xsl:value-of select="GATE_TYPE/text()" />
                  </ns2:GateType>
                </xsl:if>
                <xsl:if test="GATE_STATUS">
                  <ns2:GateBoardingStatus>
                    <xsl:value-of select="GATE_STATUS/text()" />
                  </ns2:GateBoardingStatus>
                </xsl:if>
                <xsl:if test="CHOX_TM and ATO_ARR">
                  <ns2:AXIT>
                    <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(CHOX_TM/text()),string(ATO_ARR/text()))"/>
                  </ns2:AXIT>
                </xsl:if>
                <xsl:if test="ATO_DEP and APRON_CHOX_TM">
                  <ns2:AXOT>
                    <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(ATO_DEP/text()),string(APRON_CHOX_TM/text()))"/>
                  </ns2:AXOT>
                </xsl:if>
                <xsl:if test="GROUND_HAND_END_TM and GROUND_HAND_START_TM">
                  <ns2:AGHT>
                    <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(GROUND_HAND_END_TM/text()),string(GROUND_HAND_START_TM/text()))"/>
                  </ns2:AGHT>
                </xsl:if>
                
                <!--Added 08/11/2017 - ver 3.4.57-->
                <xsl:if test="TOBT3_COUNT">
                <ns2:TOBTchangeCount>
                   <xsl:value-of select="TOBT3_COUNT/text()" />
                </ns2:TOBTchangeCount>
                 </xsl:if>
                <!--******************************-->
                
                <xsl:if test="PUSH_REJECT_CODE">
                  <ns2:PushbackContentionType>
                    <xsl:value-of select="PUSH_REJECT_CODE/text()" />
                  </ns2:PushbackContentionType>
                </xsl:if>
                <xsl:if test="PUSH_DURATION">
                  <ns2:PushbackDuration>
                    <xsl:value-of select="PUSH_DURATION/text()" />
                  </ns2:PushbackDuration>
                </xsl:if>
                <xsl:if test="AIR_START_FLG">
                  <ns2:AirStartIndicator>
                    <xsl:value-of select="AIR_START_FLG/text()" />
                  </ns2:AirStartIndicator>
                </xsl:if>
                <xsl:if test="REMOTE_HOLD_EXIT_TM and REMOTE_HOLD_ENTRY_TM">
                  <ns2:HoldingPointDuration>
                    <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(REMOTE_HOLD_EXIT_TM/text()),string(REMOTE_HOLD_ENTRY_TM/text()))"/>
                  </ns2:HoldingPointDuration>
                </xsl:if>
                <xsl:if test="LOW_VIS_FLG">
                  <ns2:LowVisibilityProcedureFlag>
                    <xsl:value-of select="LOW_VIS_FLG/text()" />
                  </ns2:LowVisibilityProcedureFlag>
                </xsl:if>
                <xsl:if test="RETN_STND_TM">
                  <ns2:ReturnToStandFlag>True</ns2:ReturnToStandFlag>
                </xsl:if>
                <xsl:if test="DISPLAYED_FLYT_NO">
                  <ns2:Franchiseflight>
                    <xsl:value-of select="DISPLAYED_FLYT_NO/text()" />
                  </ns2:Franchiseflight>
                </xsl:if>
                <xsl:if test="FLYT_RULES">
                  <ns2:FlightRule>
                    <xsl:value-of select="FLYT_RULES/text()" />
                  </ns2:FlightRule>
                </xsl:if>
                <xsl:if test="VTT">
                  <ns2:VariableTaxiTime>
                    <xsl:value-of select="VTT/text()" />
                  </ns2:VariableTaxiTime>
                </xsl:if>
                <xsl:if test="ARR_STND">
                  <ns2:ArrivalStand>
                    <xsl:value-of select="ARR_STND/text()" />
                  </ns2:ArrivalStand>
                </xsl:if>
                <xsl:if test="PROV_STND">
                  <ns2:ProvisionalStand>
                    <xsl:value-of select="PROV_STND/text()" />
                  </ns2:ProvisionalStand>
                </xsl:if>
                <xsl:if test="PLAN_RUNWAY">
                  <ns2:RunwayPlanned>
                    <xsl:value-of select="PLAN_RUNWAY/text()" />
                  </ns2:RunwayPlanned>
                </xsl:if>
                <xsl:if test="APPROACH_STND">
                  <ns2:StandAtApproach>
                    <xsl:value-of select="APPROACH_STND/text()" />
                  </ns2:StandAtApproach>
                </xsl:if>
                <xsl:if test="BAG_IND">
                  <ns2:BaggageHandlingIndicator>
                    <xsl:value-of select="BAG_IND/text()" />
                  </ns2:BaggageHandlingIndicator>
                </xsl:if>
                <xsl:if test="BAG_DISP">
                  <ns2:BaggageReclaimDisplayFlag>
                    <xsl:value-of select="BAG_DISP/text()" />
                  </ns2:BaggageReclaimDisplayFlag>
                </xsl:if>
                <xsl:if test="REQUESTED_TM">
                  <ns2:BaggageReclaimRequestedTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(REQUESTED_TM/text(),'Z')"/>
                  </ns2:BaggageReclaimRequestedTime>
                </xsl:if>
                <xsl:if test="TRANSFER_BAGS">
                  <ns2:BagsTransferedCount>
                    <xsl:value-of select="TRANSFER_BAGS/text()" />
                  </ns2:BagsTransferedCount>
                </xsl:if>
                <xsl:if test="CONVEYOR_NO">
                  <ns2:ConveyorNumber>
                    <xsl:value-of select="CONVEYOR_NO/text()" />
                  </ns2:ConveyorNumber>
                </xsl:if>
                <xsl:if test="EXEMPT_TM">
                  <ns2:GateDisableTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(EXEMPT_TM/text(),'Z')"/>
                  </ns2:GateDisableTime>
                </xsl:if>
                <xsl:if test="FIDS_FILENAME">
                  <ns2:GateFIDSFilename>
                    <xsl:value-of select="FIDS_FILENAME/text()" />
                  </ns2:GateFIDSFilename>
                </xsl:if>
                <xsl:if test="GATE_READY">
                  <ns2:GateStaffReadyForOpen>
                    <xsl:value-of select="GATE_READY/text()" />
                  </ns2:GateStaffReadyForOpen>
                </xsl:if>
                <xsl:if test="GATING_ACTION">
                  <ns2:GatingAction>
                    <xsl:value-of select="GATING_ACTION/text()" />
                  </ns2:GatingAction>
                </xsl:if>
                <xsl:if test="GATING_DUE_TM">
                  <ns2:GatingDueDateTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(GATING_DUE_TM/text(),'Z')"/>
                  </ns2:GatingDueDateTime>
                </xsl:if>
                <xsl:if test="SELECT_RANGE">
                  <ns2:LocalBoardingControlActiveRange>
                    <xsl:value-of select="SELECT_RANGE/text()" />
                  </ns2:LocalBoardingControlActiveRange>
                </xsl:if>
                <xsl:if test="SELECT_TYPE">
                  <ns2:LocalBoardingControlTypeCode>
                    <xsl:value-of select="SELECT_TYPE/text()" />
                  </ns2:LocalBoardingControlTypeCode>
                </xsl:if>
                <xsl:if test="SELECT_TEXT">
                  <ns2:LocalBoardingControlTypeDescription>
                    <xsl:value-of select="SELECT_TEXT/text()" />
                  </ns2:LocalBoardingControlTypeDescription>
                </xsl:if>
                <xsl:if test="NON_BAG_FLYT">
                  <ns2:NonBaggageFlightFlag>
                    <xsl:value-of select="NON_BAG_FLYT/text()" />
                  </ns2:NonBaggageFlightFlag>
                </xsl:if>
                <xsl:if test="SECOND_GATE">
                  <ns2:SecondaryGateNumber>
                    <xsl:value-of select="SECOND_GATE/text()" />
                  </ns2:SecondaryGateNumber>
                </xsl:if>
                <xsl:if test="STND_2">
                  <ns2:SecondaryStandNumber>
                    <xsl:value-of select="STND_2/text()" />
                  </ns2:SecondaryStandNumber>
                </xsl:if>
              </ns2:ResourceData>
              <xsl:for-each select="SPEC_NEEDS">
                <xsl:if test="count(SPEC_NEEDS_ROW) > 0">
                  <xsl:for-each select="SPEC_NEEDS_ROW">
                    <ns2:PAXRestrictedMobilityRecord>
                      <xsl:attribute name="RepeatIndex">
                        <xsl:value-of select="position()" />
                      </xsl:attribute>
                      <xsl:if test="TOT_PAX">
                        <ns2:MobilityPAXCount>
                          <xsl:value-of select="TOT_PAX/text()" />
                        </ns2:MobilityPAXCount>
                      </xsl:if>
                      <xsl:if test="CAT_CODE">
                        <ns2:MobilityType>
                          <xsl:value-of select="CAT_CODE/text()" />
                        </ns2:MobilityType>
                      </xsl:if>
                    </ns2:PAXRestrictedMobilityRecord>
                  </xsl:for-each>
                </xsl:if>
              </xsl:for-each>

              <ns2:PayLoadData>
                <xsl:if test="TRANSFER_BAGWGHT">
                  <ns2:BagsTransferredWeight>
                    <xsl:value-of select="TRANSFER_BAGWGHT/text()" />
                  </ns2:BagsTransferredWeight>
                </xsl:if>
                <xsl:if test="BALLAST_WGHT">
                  <ns2:BallastWeight>
                    <xsl:value-of select="BALLAST_WGHT/text()" />
                  </ns2:BallastWeight>
                </xsl:if>
                <xsl:if test="DEAD_LOAD">
                  <ns2:DeadLoadWeight>
                    <xsl:value-of select="DEAD_LOAD/text()" />
                  </ns2:DeadLoadWeight>
                </xsl:if>
                <xsl:if test="FRT_BOOKED_FLG">
                  <ns2:FreightBookedOrActualFlag>
                    <xsl:value-of select="FRT_BOOKED_FLG/text()" />
                  </ns2:FreightBookedOrActualFlag>
                </xsl:if>
                <xsl:if test="FRT_IND">
                  <ns2:FreightHandlingIndicator>
                    <xsl:value-of select="FRT_IND/text()" />
                  </ns2:FreightHandlingIndicator>
                </xsl:if>
              </ns2:PayLoadData>

              <ns2:MiscFlightLegData>
                <xsl:if test="FLYT_DECK_CREW">
                  <ns2:AircrewCount>
                    <xsl:value-of select="FLYT_DECK_CREW/text()" />
                  </ns2:AircrewCount>
                </xsl:if>
                <xsl:if test="DMAN_PRIORITY">
                  <ns2:AirlinePriorityFlag>
                    <xsl:value-of select="DMAN_PRIORITY/text()" />
                  </ns2:AirlinePriorityFlag>
                </xsl:if>
                <xsl:if test="ALLIANCE">
                  <ns2:AllianceCode>
                    <xsl:value-of select="ALLIANCE/text()" />
                  </ns2:AllianceCode>
                </xsl:if>
                <xsl:if test="AUTO_BOARDING">
                  <ns2:AutomaticBoardingFlag>
                    <xsl:value-of select="AUTO_BOARDING/text()" />
                  </ns2:AutomaticBoardingFlag>
                </xsl:if>
                <xsl:if test="BAGS_NUMBER">
                  <ns2:BagsCount>
                    <xsl:value-of select="BAGS_NUMBER/text()" />
                  </ns2:BagsCount>
                </xsl:if>
                <xsl:if test="BRD_END">
                  <ns2:BoardingEndTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(BRD_END/text(),'Z')"/>
                  </ns2:BoardingEndTime>
                </xsl:if>
                <xsl:if test="CAA_FLYT_TYPE">
                  <ns2:CAAFlightType>
                    <xsl:value-of select="CAA_FLYT_TYPE/text()" />
                  </ns2:CAAFlightType>
                </xsl:if>
                <xsl:if test="CABIN_CREW_NO">
                  <ns2:CabinCrewCount>
                    <xsl:value-of select="CABIN_CREW_NO/text()" />
                  </ns2:CabinCrewCount>
                </xsl:if>
                <xsl:if test="CALLS_NO">
                  <ns2:CallsCount>
                    <xsl:value-of select="CALLS_NO/text()" />
                  </ns2:CallsCount>
                </xsl:if>
                <xsl:if test="CDM05">
                  <ns2:CDMAlert50>
                    <xsl:value-of select="CDM05/text()" />
                  </ns2:CDMAlert50>
                </xsl:if>
                <xsl:if test="CONFLICTING_STAND2">
                  <ns2:ConflictingStand2>
                    <xsl:value-of select="CONFLICTING_STAND2/text()" />
                  </ns2:ConflictingStand2>
                </xsl:if>
                <xsl:if test="CREW_NO">
                  <ns2:CrewPersonnelCount>
                    <xsl:value-of select="CREW_NO/text()" />
                  </ns2:CrewPersonnelCount>
                </xsl:if>
                <xsl:if test="DIV_CODE">
                  <ns2:DivertReasonCode>
                    <xsl:value-of select="DIV_CODE/text()" />
                  </ns2:DivertReasonCode>
                </xsl:if>
                <!--<xsl:if test="TODO">
                  <ns2:DoNotSequenceFlightFlag>
                    <xsl:value-of select="FRT_IND/text()" />
                  </ns2:DoNotSequenceFlightFlag>
                </xsl:if>-->
                <xsl:if test="DUNN_ACT1">
                  <ns2:DunnActual1>
                    <xsl:value-of select="DUNN_ACT1/text()" />
                  </ns2:DunnActual1>
                </xsl:if>
                <xsl:if test="DUNN_ACT2">
                  <ns2:DunnActual2>
                    <xsl:value-of select="DUNN_ACT2/text()" />
                  </ns2:DunnActual2>
                </xsl:if>
                <xsl:if test="DUNN_ACT3">
                  <ns2:DunnActual3>
                    <xsl:value-of select="DUNN_ACT3/text()" />
                  </ns2:DunnActual3>
                </xsl:if>
                <xsl:if test="DUNN_ACT4">
                  <ns2:DunnActual4>
                    <xsl:value-of select="DUNN_ACT4/text()" />
                  </ns2:DunnActual4>
                </xsl:if>
                <xsl:if test="ENG_STA_FLG">
                  <ns2:EngineStartupFlag>
                    <xsl:value-of select="ENG_STA_FLG/text()" />
                  </ns2:EngineStartupFlag>
                </xsl:if>
                <xsl:if test="ETO_TYPE">
                  <ns2:ETOTypeExternal>
                    <xsl:value-of select="ETO_TYPE/text()" />
                  </ns2:ETOTypeExternal>
                </xsl:if>
                <xsl:if test="FEE_POSTED6">
                  <ns2:FeePosted06>
                    <xsl:value-of select="FEE_POSTED6/text()" />
                  </ns2:FeePosted06>
                </xsl:if>
                <xsl:if test="FEE_POSTED7">
                  <ns2:FeePosted07>
                    <xsl:value-of select="FEE_POSTED7/text()" />
                  </ns2:FeePosted07>
                </xsl:if>
                <xsl:if test="FEE_POSTED8">
                  <ns2:FeePosted08>
                    <xsl:value-of select="FEE_POSTED8/text()" />
                  </ns2:FeePosted08>
                </xsl:if>
                <xsl:if test="FEE_POSTED9">
                  <ns2:FeePosted09>
                    <xsl:value-of select="FEE_POSTED9/text()" />
                  </ns2:FeePosted09>
                </xsl:if>
                <xsl:if test="FEE_POSTED10">
                  <ns2:FeePosted10>
                    <xsl:value-of select="FEE_POSTED10/text()" />
                  </ns2:FeePosted10>
                </xsl:if>
                <xsl:if test="FLASHERS">
                  <ns2:FlashersOnOffFlag>
                    <xsl:value-of select="FLASHERS/text()" />
                  </ns2:FlashersOnOffFlag>
                </xsl:if>
                <xsl:if test="FLYT_CALL">
                  <ns2:FlightCalledFlag>
                    <xsl:value-of select="FLYT_CALL/text()" />
                  </ns2:FlightCalledFlag>
                </xsl:if>
                <xsl:if test="CANCELLED">
                  <ns2:FlightCancelledFlag>
                    <xsl:value-of select="CANCELLED/text()" />
                  </ns2:FlightCancelledFlag>
                </xsl:if>
                <xsl:if test="CLEARED">
                  <ns2:FlightClearedTime>
                    <xsl:value-of select="CLEARED/text()" />
                  </ns2:FlightClearedTime>
                </xsl:if>
                <xsl:if test="FLYT_CREATE_TM">
                  <ns2:FlightCreationTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FLYT_CREATE_TM/text(),'Z')"/>
                  </ns2:FlightCreationTime>
                </xsl:if>
                <xsl:if test="LAST_USR">
                  <ns2:FlightLastChangedBy>
                    <xsl:value-of select="LAST_USR/text()" />
                  </ns2:FlightLastChangedBy>
                </xsl:if>
                <xsl:if test="FLYT_LEVEL">
                  <ns2:FlightLevel>
                    <xsl:value-of select="FLYT_LEVEL/text()" />
                  </ns2:FlightLevel>
                </xsl:if>
                <!--<xsl:if test="TODO">
                  <ns2:FlightModifiedFlag>
                    <xsl:value-of select="FRT_IND/text()" />
                  </ns2:FlightModifiedFlag>
                </xsl:if>-->
                <xsl:if test="FLYT_PLANNED_TM">
                  <ns2:FlightPlannedTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FLYT_PLANNED_TM/text(),'Z')"/>
                  </ns2:FlightPlannedTime>
                </xsl:if>
                <xsl:if test="FLYT_STATUS">
                  <ns2:FlightStatus>
                    <xsl:value-of select="FLYT_STATUS/text()" />
                  </ns2:FlightStatus>
                </xsl:if>
                <xsl:if test="STATUS_CHG">
                  <ns2:FlightStatusChangeTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(STATUS_CHG/text(),'Z')"/>
                  </ns2:FlightStatusChangeTime>
                </xsl:if>
                <xsl:if test="FLYT_TM">
                  <ns2:FlightTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FLYT_TM/text(),'Z')"/>
                  </ns2:FlightTime>
                </xsl:if>
                <xsl:if test="HA_STO">
                  <ns2:HandlingAgentsSTO>
                    <xsl:value-of select="HA_STO/text()" />
                  </ns2:HandlingAgentsSTO>
                </xsl:if>
                <xsl:if test="HANDLING_CREW_NO">
                  <ns2:HandlingCrewCount>
                    <xsl:value-of select="HANDLING_CREW_NO/text()" />
                  </ns2:HandlingCrewCount>
                </xsl:if>
                <xsl:if test="HANDLING_TEAM">
                  <ns2:HandlingTeamID>
                    <xsl:value-of select="HANDLING_TEAM/text()" />
                  </ns2:HandlingTeamID>
                </xsl:if>
                <xsl:if test="LAND">
                  <ns2:LinkedArrivalonLanding>
                    <xsl:value-of select="LAND/text()" />
                  </ns2:LinkedArrivalonLanding>
                </xsl:if>
                <xsl:if test="LINKED_REC_NO">
                  <ns2:LinkedFlightRecNo>
                    <xsl:value-of select="LINKED_REC_NO/text()" />
                  </ns2:LinkedFlightRecNo>
                </xsl:if>
                <xsl:if test="LINKED_STO">
                  <ns2:LinkedFlightScheduleTimeGAL>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(LINKED_STO/text(),'Z')"/>
                  </ns2:LinkedFlightScheduleTimeGAL>
                </xsl:if>
                <xsl:if test="EXIT_POINT">
                  <ns2:NationalAirspaceExitPoint>
                    <xsl:value-of select="EXIT_POINT/text()" />
                  </ns2:NationalAirspaceExitPoint>
                </xsl:if>
                <xsl:if test="NEW_FLYT">
                  <ns2:NewFlightFlag>
                    <xsl:value-of select="NEW_FLYT/text()" />
                  </ns2:NewFlightFlag>
                </xsl:if>
                <xsl:if test="NSC_POSTED">
                  <ns2:NSCfeePosted>
                    <xsl:value-of select="NSC_POSTED/text()" />
                  </ns2:NSCfeePosted>
                </xsl:if>
                <xsl:if test="NSD_BOOKOUT">
                  <ns2:NSDBookOut>
                    <xsl:value-of select="NSD_BOOKOUT/text()" />
                  </ns2:NSDBookOut>
                </xsl:if>
                <xsl:if test="NO_OF_APPROACHES">
                  <ns2:NumberOfApproaches>
                    <xsl:value-of select="NO_OF_APPROACHES/text()" />
                  </ns2:NumberOfApproaches>
                </xsl:if>
                <xsl:if test="PARK_SIDE_ON">
                  <ns2:ParkedSideOnFlag>
                    <xsl:value-of select="PARK_SIDE_ON/text()" />
                  </ns2:ParkedSideOnFlag>
                </xsl:if>
                <xsl:if test="GO_PASSPORT_CONT">
                  <ns2:PassportControlTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(GO_PASSPORT_CONT/text(),'Z')"/>
                  </ns2:PassportControlTime>
                </xsl:if>
                <xsl:if test="PAX_BOOKED_FLG">
                  <ns2:PAXBookedOrActual>
                    <xsl:value-of select="PAX_BOOKED_FLG/text()" />
                  </ns2:PAXBookedOrActual>
                </xsl:if>
                <xsl:if test="PLS_POSTED">
                  <ns2:PLSPostedFlag>
                    <xsl:value-of select="PLS_POSTED/text()" />
                  </ns2:PLSPostedFlag>
                </xsl:if>
                <xsl:if test="PTO">
                  <ns2:ProbableTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(PTO/text(),'Z')"/>
                  </ns2:ProbableTime>
                </xsl:if>
                <xsl:if test="PTO_INDEX">
                  <ns2:ProbableTimeIndex>
                    <xsl:value-of select="PTO_INDEX/text()" />
                  </ns2:ProbableTimeIndex>
                </xsl:if>
                <xsl:if test="RECLEARANCE_TM">
                  <ns2:ReClearanceTimeDuration>
                    <xsl:value-of select="RECLEARANCE_TM/text()" />
                  </ns2:ReClearanceTimeDuration>
                </xsl:if>
                <xsl:if test="REC_ORIGIN">
                  <ns2:RecordCreatedBy>
                    <xsl:value-of select="REC_ORIGIN/text()" />
                  </ns2:RecordCreatedBy>
                </xsl:if>
                <xsl:if test="REC_DEL_FLG">
                  <ns2:RecordDeletedFlag>
                    <xsl:value-of select="REC_DEL_FLG/text()" />
                  </ns2:RecordDeletedFlag>
                </xsl:if>
                <xsl:if test="REC_UPD_TM">
                  <ns2:RecordLastUpdateTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(REC_UPD_TM/text(),'Z')"/>
                  </ns2:RecordLastUpdateTime>
                </xsl:if>
                <xsl:if test="RETN_AIRBORNE_TM">
                  <ns2:ReturnedFromAirbourneTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(RETN_AIRBORNE_TM/text(),'Z')"/>
                  </ns2:ReturnedFromAirbourneTime>
                </xsl:if>
                <!--<xsl:if test="TODO">
                  <ns2:ScheduledDateTimeAtFlightOrigin>
                    <xsl:value-of select="FRT_IND/text()" />
                  </ns2:ScheduledDateTimeAtFlightOrigin>
                </xsl:if>-->
                <xsl:if test="STO_INDEX">
                  <ns2:SchedulesTimeIndex>
                    <xsl:value-of select="STO_INDEX/text()" />
                  </ns2:SchedulesTimeIndex>
                </xsl:if>
                <xsl:if test="SLOT_TYPE">
                  <ns2:SlotBookingType>
                    <xsl:value-of select="SLOT_TYPE/text()" />
                  </ns2:SlotBookingType>
                </xsl:if>
                <xsl:if test="SPECIAL_NEEDS">
                  <ns2:SpecialNeedsCount>
                    <xsl:value-of select="SPECIAL_NEEDS/text()" />
                  </ns2:SpecialNeedsCount>
                </xsl:if>
                <!--<xsl:if test="TODO">
                  <ns2:TaxiTimeEnd>
                    <xsl:value-of select="FRT_IND/text()" />
                  </ns2:TaxiTimeEnd>
                </xsl:if>  
                          <xsl:if test="TODO">
                  <ns2:TaxiTimeStart>
                    <xsl:value-of select="FRT_IND/text()" />
                  </ns2:TaxiTimeStart>
                </xsl:if>-->
                <xsl:if test="TOUCH_DOWN">
                  <ns2:TouchdownsCount>
                    <xsl:value-of select="TOUCH_DOWN/text()" />
                  </ns2:TouchdownsCount>
                </xsl:if>
                <xsl:if test="TOUR_OP">
                  <ns2:TourOperator>
                    <xsl:value-of select="TOUR_OP/text()" />
                  </ns2:TourOperator>
                </xsl:if>
                <xsl:if test="TRAVEL_AGNT">
                  <ns2:TravelAgent>
                    <xsl:value-of select="TRAVEL_AGNT/text()" />
                  </ns2:TravelAgent>
                </xsl:if>
                <xsl:if test="TRUE_AIRSPEED">
                  <ns2:TrueAirspeed>
                    <xsl:value-of select="TRUE_AIRSPEED/text()" />
                  </ns2:TrueAirspeed>
                </xsl:if>
                <xsl:if test="TSAT_LOCK_FLG">
                  <ns2:TSATLockFlag>
                    <xsl:value-of select="TSAT_LOCK_FLG/text()" />
                  </ns2:TSATLockFlag>
                </xsl:if>
                <xsl:if test="WILLBOARD_TM">
                  <ns2:WillboardTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(WILLBOARD_TM/text(),'Z')"/>
                  </ns2:WillboardTime>
                </xsl:if>
              </ns2:MiscFlightLegData>
              <ns2:CodeSharesData>


                <xsl:if test="CODE_SHARES">
                  <ns2:AllCodeShares>
                    <xsl:value-of select="CODE_SHARES/text()" />
                  </ns2:AllCodeShares>
                </xsl:if>
                <xsl:for-each select="FLIGHT_CODE_SHARES/FLIGHT_CODE_SHARES_ROW">
                  <ns2:CodeShares>
                    <xsl:attribute name="RepeatIndex">
                      <xsl:value-of select="string(userCSharp:GetNextCSIndex())" />
                    </xsl:attribute>
                    <xsl:if test="ARR_DEP">
                      <ns2:ArrivalDeparture>
                        <xsl:value-of select="ARR_DEP/text()" />
                      </ns2:ArrivalDeparture>
                    </xsl:if>
                    <xsl:if test="FIDS_AREA">
                      <ns2:FIDSArea>
                        <xsl:value-of select="FIDS_AREA/text()" />
                      </ns2:FIDSArea>
                    </xsl:if>
                    <xsl:if test="FIDS_POLICY">
                      <ns2:FIDSPolicy>
                        <xsl:value-of select="FIDS_POLICY/text()" />
                      </ns2:FIDSPolicy>
                    </xsl:if>
                    <xsl:if test="FRANCHISE_FLG">
                      <ns2:FranchiseFlag>
                        <xsl:value-of select="FRANCHISE_FLG/text()" />
                      </ns2:FranchiseFlag>
                    </xsl:if>
                    <xsl:if test="OSTO">
                      <ns2:OriginScheduleTime>
                        <xsl:value-of select="ScriptNS0:FormatOracleDateTime(OSTO/text(),'Z')"/>
                      </ns2:OriginScheduleTime>
                    </xsl:if>
                    <xsl:if test="STO">
                      <ns2:ScheduleTime>
                        <xsl:value-of select="ScriptNS0:FormatOracleDateTime(STO/text(),'Z')"/>
                      </ns2:ScheduleTime>
                    </xsl:if>
                    <xsl:if test="UPD_DATE">
                      <ns2:UpdatedDate>
                        <xsl:value-of select="ScriptNS0:FormatOracleDateTime(UPD_DATE/text(),'Z')"/>
                      </ns2:UpdatedDate>
                    </xsl:if>
                    <xsl:if test="UPD_DEPT">
                      <ns2:UpdatedDepartment>
                        <xsl:value-of select="UPD_DEPT/text()" />
                      </ns2:UpdatedDepartment>
                    </xsl:if>
                    <xsl:if test="UPD_USER">
                      <ns2:UpdatedUser>
                        <xsl:value-of select="UPD_USER/text()" />
                      </ns2:UpdatedUser>
                    </xsl:if>
                  </ns2:CodeShares>
                </xsl:for-each>
              </ns2:CodeSharesData>

              <ns2:FlightPlanData>
                <xsl:if test="FLIGHT_PLAN_REG">
                  <ns2:AircraftRegistration>
                    <xsl:value-of select="FLIGHT_PLAN_REG/text()" />
                  </ns2:AircraftRegistration>
                </xsl:if>
                <xsl:if test="ARCID">
                  <ns2:Callsign>
                    <xsl:value-of select="ARCID/text()" />
                  </ns2:Callsign>
                </xsl:if>
                <xsl:if test="ROUTE">
                  <ns2:CompleteRoutingDetail>
                    <xsl:value-of select="ROUTE/text()" />
                  </ns2:CompleteRoutingDetail>
                </xsl:if>
                <xsl:if test="ORIGIN">
                  <ns2:CreationOrigin>
                    <xsl:value-of select="ORIGIN/text()" />
                  </ns2:CreationOrigin>
                </xsl:if>
                <xsl:if test="ETA">
                  <ns2:EstimatedArrivalTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ETA/text(),'Z')"/>
                  </ns2:EstimatedArrivalTime>
                </xsl:if>
                <xsl:if test="EOBD">
                  <ns2:EstimatedOffBlockdate>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(EOBD/text(),'')"/>
                  </ns2:EstimatedOffBlockdate>
                </xsl:if>
                <xsl:if test="EOBT">
                  <ns2:EstimatedOffBlocktime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(EOBT/text(),'')"/>
                  </ns2:EstimatedOffBlocktime>
                </xsl:if>
                <xsl:if test="ETOD">
                  <ns2:EstimatedTakeOffDate>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ETOD/text(),'Z')"/>
                  </ns2:EstimatedTakeOffDate>
                </xsl:if>
                <xsl:if test="ETOT">
                  <ns2:EstimatedTakeOffTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(ETOT/text(),'Z')"/>
                  </ns2:EstimatedTakeOffTime>
                </xsl:if>
                <xsl:if test="FLTTYP">
                  <ns2:FlightCategory>
                    <xsl:value-of select="FLTTYP/text()" />
                  </ns2:FlightCategory>
                </xsl:if>
                <xsl:if test="IFPLID">
                  <ns2:FlightPlanID>
                    <xsl:value-of select="IFPLID/text()" />
                  </ns2:FlightPlanID>
                </xsl:if>
                <xsl:if test="FPL_STATUS">
                  <ns2:FlightPlanStatus>
                    <xsl:value-of select="FPL_STATUS/text()" />
                  </ns2:FlightPlanStatus>
                </xsl:if>
                <xsl:if test="ARCTYP">
                  <ns2:ICAOAircraftType>
                    <xsl:value-of select="ARCTYP/text()" />
                  </ns2:ICAOAircraftType>
                </xsl:if>
                <xsl:if test="HOST_AIRPORT">
                  <ns2:ICAOAirportCode>
                    <xsl:value-of select="HOST_AIRPORT/text()" />
                  </ns2:ICAOAirportCode>
                </xsl:if>
                <xsl:if test="ALTNZ">
                  <ns2:ICAOalternateAerodromes>
                    <xsl:value-of select="ALTNZ/text()" />
                  </ns2:ICAOalternateAerodromes>
                </xsl:if>
                <xsl:if test="ADEP">
                  <ns2:ICAOdepartureAerodrome>
                    <xsl:value-of select="ADEP/text()" />
                  </ns2:ICAOdepartureAerodrome>
                </xsl:if>
                <xsl:if test="ADES">
                  <ns2:ICAOdestinationAerodrome>
                    <xsl:value-of select="ADES/text()" />
                  </ns2:ICAOdestinationAerodrome>
                </xsl:if>
                <xsl:if test="FLTRUL">
                  <ns2:IntendedFlightRule>
                    <xsl:value-of select="FLTRUL/text()" />
                  </ns2:IntendedFlightRule>
                </xsl:if>
                <xsl:if test="CEQPT">
                  <ns2:RadioNavEquipment>
                    <xsl:value-of select="CEQPT/text()" />
                  </ns2:RadioNavEquipment>
                </xsl:if>
                <xsl:if test="RMK">
                  <ns2:Remarks>
                    <xsl:value-of select="RMK/text()" />
                  </ns2:Remarks>
                </xsl:if>
                <xsl:if test="RFL">
                  <ns2:RequestedFlightLevel>
                    <xsl:value-of select="RFL/text()" />
                  </ns2:RequestedFlightLevel>
                </xsl:if>
                <xsl:if test="SSRCODE">
                  <ns2:SSRTransponderCode>
                    <xsl:value-of select="SSRCODE/text()" />
                  </ns2:SSRTransponderCode>
                </xsl:if>
                <xsl:if test="SEQPT">
                  <ns2:SurveillanceEquipment>
                    <xsl:value-of select="SEQPT/text()" />
                  </ns2:SurveillanceEquipment>
                </xsl:if>
                <xsl:if test="FILTIM">
                  <ns2:TimeOfMessageTransmission>
                    <xsl:value-of select="FILTIM/text()" />
                  </ns2:TimeOfMessageTransmission>
                </xsl:if>
                <xsl:if test="SPEED">
                  <ns2:TrueAirSpeed>
                    <xsl:value-of select="SPEED/text()" />
                  </ns2:TrueAirSpeed>
                </xsl:if>
                <xsl:if test="WKTRC">
                  <ns2:WakeTurbulenceCategory>
                    <xsl:value-of select="WKTRC/text()" />
                  </ns2:WakeTurbulenceCategory>
                </xsl:if>

              </ns2:FlightPlanData>

              <ns2:LastDPIdata>
                <xsl:if test="LAST_DPI_ACRFT_TYPE">
                  <ns2:AircraftType>
                    <xsl:value-of select="LAST_DPI_ACRFT_TYPE/text()" />
                  </ns2:AircraftType>
                </xsl:if>
                <xsl:if test="LAST_DPI_ETO">
                  <ns2:ETO>
                    <xsl:value-of select="LAST_DPI_ETO/text()" />
                  </ns2:ETO>
                </xsl:if>
                <xsl:if test="LAST_DPI_EXOT">
                  <ns2:EXOT>
                    <xsl:value-of select="LAST_DPI_EXOT/text()" />
                  </ns2:EXOT>
                </xsl:if>
                <xsl:if test="LAST_DPI_REG">
                  <ns2:Registration>
                    <xsl:value-of select="LAST_DPI_REG/text()" />
                  </ns2:Registration>
                </xsl:if>
                <xsl:if test="LAST_DPI_SID">
                  <ns2:SID>
                    <xsl:value-of select="LAST_DPI_SID/text()" />
                  </ns2:SID>
                </xsl:if>
                <xsl:if test="LAST_DPI_TSAT">
                  <ns2:TSAT>
                    <xsl:value-of select="LAST_DPI_TSAT/text()" />
                  </ns2:TSAT>
                </xsl:if>
                <xsl:if test="LAST_DPI_TYPE">
                  <ns2:TYPE>
                    <xsl:value-of select="LAST_DPI_TYPE/text()" />
                  </ns2:TYPE>
                </xsl:if>
              </ns2:LastDPIdata>

              <ns2:DelayCodeData>
                <xsl:for-each select="DELAYS/DELAYS_ROW">
                  <ns2:Delay>
                    <xsl:attribute name="RepeatIndex">
                      <xsl:value-of select="string(userCSharp:GetNextDelayIndex2())" />
                    </xsl:attribute>
                    <xsl:if test="FDAGNT">
                      <ns2:Agent>
                        <xsl:value-of select="FDAGNT/text()" />
                      </ns2:Agent>
                    </xsl:if>
                    <xsl:if test="FDAORD">
                      <ns2:ArrivalOrDeparture>
                        <xsl:value-of select="FDAORD/text()" />
                      </ns2:ArrivalOrDeparture>
                    </xsl:if>
                    <xsl:if test="FDDEPT">
                      <ns2:Department>
                        <xsl:value-of select="FDDEPT/text()" />
                      </ns2:Department>
                    </xsl:if>
                    <xsl:if test="FDFLTN">
                      <ns2:FlightNumber>
                        <xsl:value-of select="FDFLTN/text()" />
                      </ns2:FlightNumber>
                    </xsl:if>
                    <xsl:if test="FDOPER">
                      <ns2:Operator>
                        <xsl:value-of select="FDOPER/text()" />
                      </ns2:Operator>
                    </xsl:if>
                    <xsl:if test="FDRECN">
                      <ns2:RecordNumber>
                        <xsl:value-of select="FDRECN/text()" />
                      </ns2:RecordNumber>
                    </xsl:if>
                    <xsl:if test="FDSTO">
                      <ns2:ScheduledTime>
                        <xsl:value-of select="ScriptNS0:FormatOracleDateTime(FDSTO/text(),'Z')"/>
                      </ns2:ScheduledTime>
                    </xsl:if>
                    <xsl:if test="FDUSER">
                      <ns2:User>
                        <xsl:value-of select="FDUSER/text()" />
                      </ns2:User>
                    </xsl:if>
                    <xsl:if test="FDDLY1">
                      <ns2:AlphaCode>
                        <xsl:value-of select="FDDLY1/text()" />
                      </ns2:AlphaCode>
                    </xsl:if>
                    <xsl:if test="FDDUR">
                      <ns2:Duration>
                        <xsl:value-of select="FDDUR/text()" />
                      </ns2:Duration>
                    </xsl:if>
                    <xsl:if test="FDDLY2">
                      <ns2:NumericCode>
                        <xsl:value-of select="FDDLY2/text()" />
                      </ns2:NumericCode>
                    </xsl:if>

                  </ns2:Delay>
                </xsl:for-each >
              </ns2:DelayCodeData>

            </ns2:FlightLegExtension>

            <ns2:PortsOfCallExtras>

              <xsl:if test="string($var:arrdep)='Arrival'">

                <xsl:if test="IATA_LOC1">
                  <ns2:PortOfCall RepeatIndex="1">
                    <xsl:if test="COUNTRY_CODE1">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE1/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <xsl:if test="PUBLOC1">
                      <ns2:PublicLocationName>
                        <xsl:value-of select="PUBLOC1/text()" />
                      </ns2:PublicLocationName>
                    </xsl:if>
                    <xsl:if test="ICAO_LOC1">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC1/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC1/text()" />
                    </ns2:IATALocationCode>


                  </ns2:PortOfCall>
                </xsl:if>

                <xsl:if test="IATA_LOC5">
                  <ns2:PortOfCall RepeatIndex="2">
                    <xsl:if test="COUNTRY_CODE5">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE5/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <!--<ns2:PublicLocationName>TODO</ns2:PublicLocationName>-->
                    <xsl:if test="ICAO_LOC5">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC5/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC5/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC5">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC5/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY5">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY5/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC5">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC5/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC5">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC5/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC5">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC5/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

                <xsl:if test="IATA_LOC4">
                  <ns2:PortOfCall RepeatIndex="3">
                    <xsl:if test="COUNTRY_CODE4">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE4/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <!--<ns2:PublicLocationName>TODO</ns2:PublicLocationName>-->
                    <xsl:if test="ICAO_LOC4">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC4/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC4/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC4">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC4/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY4">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY4/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC4">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC4/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC4">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC4/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC4">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC4/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

                <xsl:if test="IATA_LOC3">
                  <ns2:PortOfCall RepeatIndex="4">
                    <xsl:if test="COUNTRY_CODE3">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE3/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <xsl:if test="PUBLOC3">
                      <ns2:PublicLocationName>
                        <xsl:value-of select="PUBLOC3/text()" />
                      </ns2:PublicLocationName>
                    </xsl:if>
                    <xsl:if test="ICAO_LOC3">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC3/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC3/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC3">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC3/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY3">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY3/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC3">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC3/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC3">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC3/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC3">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC3/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

                <xsl:if test="IATA_LOC2">
                  <ns2:PortOfCall RepeatIndex="5">
                    <xsl:if test="COUNTRY_CODE2">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE2/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <xsl:if test="PUBLOC2">
                      <ns2:PublicLocationName>
                        <xsl:value-of select="PUBLOC2/text()" />
                      </ns2:PublicLocationName>
                    </xsl:if>
                    <xsl:if test="ICAO_LOC2">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC2/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC2/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC2">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC2/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY2">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY2/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC2">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC2/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC2">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC2/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC2">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC2/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

              </xsl:if>

              <xsl:if test="string($var:arrdep)='Departure'">
                <xsl:if test="IATA_LOC2">
                  <ns2:PortOfCall RepeatIndex="1">
                    <xsl:if test="COUNTRY_CODE2">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE2/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <xsl:if test="PUBLOC2">
                      <ns2:PublicLocationName>
                        <xsl:value-of select="PUBLOC2/text()" />
                      </ns2:PublicLocationName>
                    </xsl:if>
                    <xsl:if test="ICAO_LOC2">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC2/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC2/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC2">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC2/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY2">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY2/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC2">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC2/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC2">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC2/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC2">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC2/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>
                <xsl:if test="IATA_LOC3">
                  <ns2:PortOfCall RepeatIndex="2">
                    <xsl:if test="COUNTRY_CODE3">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE3/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <xsl:if test="PUBLOC3">
                      <ns2:PublicLocationName>
                        <xsl:value-of select="PUBLOC3/text()" />
                      </ns2:PublicLocationName>
                    </xsl:if>
                    <xsl:if test="ICAO_LOC3">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC3/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC3/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC3">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC3/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY3">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY3/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC3">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC3/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC3">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC3/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC3">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC3/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>
                <xsl:if test="IATA_LOC4">
                  <ns2:PortOfCall RepeatIndex="3">
                    <xsl:if test="COUNTRY_CODE4">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE4/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <!--<ns2:PublicLocationName>TODO</ns2:PublicLocationName>-->
                    <xsl:if test="ICAO_LOC4">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC4/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC4/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC4">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC4/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY4">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY4/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC4">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC4/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC4">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC4/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC4">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC4/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

                <xsl:if test="IATA_LOC5">
                  <ns2:PortOfCall RepeatIndex="4">
                    <xsl:if test="COUNTRY_CODE5">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE5/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <!--<ns2:PublicLocationName>TODO</ns2:PublicLocationName>-->
                    <xsl:if test="ICAO_LOC5">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC5/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC5/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC5">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC5/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY5">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY5/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC5">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC5/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC5">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC5/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC5">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC5/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

                <xsl:if test="IATA_LOC1">
                  <ns2:PortOfCall RepeatIndex="5">
                    <xsl:if test="COUNTRY_CODE1">
                      <ns2:IATACountryCode>
                        <xsl:value-of select="COUNTRY_CODE1/text()" />
                      </ns2:IATACountryCode>
                    </xsl:if>
                    <xsl:if test="PUBLOC1">
                      <ns2:PublicLocationName>
                        <xsl:value-of select="PUBLOC1/text()" />
                      </ns2:PublicLocationName>
                    </xsl:if>
                    <xsl:if test="ICAO_LOC1">
                      <ns2:ICAOLocationCode>
                        <xsl:value-of select="ICAO_LOC1/text()" />
                      </ns2:ICAOLocationCode>
                    </xsl:if>
                    <ns2:IATALocationCode>
                      <xsl:value-of select="IATA_LOC1/text()" />
                    </ns2:IATALocationCode>
                    <xsl:if test="BAGS_LOC1">
                      <ns2:BagWeightLocation>
                        <xsl:value-of select="BAGS_LOC1/text()" />
                      </ns2:BagWeightLocation>
                    </xsl:if>
                    <xsl:if test="EST_FLY1">
                      <ns2:EstimatedFlyingTimeDuration>
                        <xsl:value-of select="EST_FLY1/text()" />
                      </ns2:EstimatedFlyingTimeDuration>
                    </xsl:if>
                    <xsl:if test="FRT_LOC1">
                      <ns2:FreightWeightLocation>
                        <xsl:value-of select="FRT_LOC1/text()" />
                      </ns2:FreightWeightLocation>
                    </xsl:if>
                    <xsl:if test="LINKED_IATA_LOC1">
                      <ns2:LinkedIATALocation>
                        <xsl:value-of select="LINKED_IATA_LOC1/text()" />
                      </ns2:LinkedIATALocation>
                    </xsl:if>
                    <xsl:if test="MAIL_LOC1">
                      <ns2:MailWeightLocation>
                        <xsl:value-of select="MAIL_LOC1/text()" />
                      </ns2:MailWeightLocation>
                    </xsl:if>
                  </ns2:PortOfCall>
                </xsl:if>

              </xsl:if>


              <!--<xsl:if test="IATA_LOC6">
                <ns2:PortOfCall RepeatIndex="6">
                  <xsl:if test="COUNTRY_CODE6">
                    <ns2:IATACountryCode>
                      <xsl:value-of select="COUNTRY_CODE6/text()" />
                    </ns2:IATACountryCode>
                  </xsl:if>
                  <ns2:PublicLocationName>TODO</ns2:PublicLocationName>
                  <xsl:if test="ICAO_LOC6">
                    <ns2:ICAOLocationCode>
                      <xsl:value-of select="ICAO_LOC6/text()" />
                    </ns2:ICAOLocationCode>
                  </xsl:if>
                  <ns2:IATALocationCode>
                    <xsl:value-of select="IATA_LOC6/text()" />
                  </ns2:IATALocationCode>
                </ns2:PortOfCall>
              </xsl:if>-->

              <xsl:if test="HA_IATA_LOC6">
                <ns2:HandlingAgentsLPOCorFPOC>
                  <xsl:value-of select="HA_IATA_LOC6/text()" />
                </ns2:HandlingAgentsLPOCorFPOC>
              </xsl:if>
              <xsl:if test="HA_IATA_LOC1">
                <ns2:HandlingAgentsOriginOrDestination>
                  <xsl:value-of select="HA_IATA_LOC1/text()" />
                </ns2:HandlingAgentsOriginOrDestination>
              </xsl:if>
              <xsl:if test="LPOC_ETO">
                <ns2:LastPortOfCallEstimatedTimeOfOperation>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(LPOC_ETO/text()),'Z')"/>
                </ns2:LastPortOfCallEstimatedTimeOfOperation>
              </xsl:if>
              <xsl:if test="LPOC_STO">
                <ns2:LastPortOfCallScheduledTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(LPOC_STO/text()),'Z')"/>
                </ns2:LastPortOfCallScheduledTime>
              </xsl:if>


            </ns2:PortsOfCallExtras>

            <ns2:ServiceResourceRecords>
              <xsl:if test="CATERING_CREW">
                <ns2:CateringCrewCount>
                  <xsl:value-of select="CATERING_CREW/text()" />
                </ns2:CateringCrewCount>
              </xsl:if>
              <xsl:if test="CATERING_IND">
                <ns2:CateringHandlingIndicator>
                  <xsl:value-of select="CATERING_IND/text()" />
                </ns2:CateringHandlingIndicator>
              </xsl:if>
              <xsl:if test="CATERING_LOADER">
                <ns2:CateringLoaderNumber>
                  <xsl:value-of select="CATERING_LOADER/text()" />
                </ns2:CateringLoaderNumber>
              </xsl:if>
            </ns2:ServiceResourceRecords>

            <ns2:PublicDisplayData>
              <ns2:PublicCarrierCode>
                <xsl:value-of select="OP_CODE/text()" />
              </ns2:PublicCarrierCode>
              <xsl:if test="FLYT_NO">
                <ns2:PublicFlightNumber>
                  <xsl:value-of select="$var:flightno" />
                </ns2:PublicFlightNumber>
              </xsl:if>
              <xsl:if test="QUEBEC">
                <ns2:PublicFlightSuffix>
                  <xsl:value-of select="QUEBEC/text()" />
                </ns2:PublicFlightSuffix>
              </xsl:if>
              <xsl:if test="OFFERED_TM">
                <ns2:PublicEstimatedDateTime>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(OFFERED_TM/text()),'Z')"/>
                </ns2:PublicEstimatedDateTime>
              </xsl:if>
              <xsl:if test="ATO">
                <xsl:if test="ATO/text() != ''">
                  <ns2:PublicOperatedDateTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(ATO/text()),'Z')"/>
                  </ns2:PublicOperatedDateTime>
                </xsl:if>
              </xsl:if>
              <xsl:if test="STO">
                <xsl:if test="STO/text() != ''">
                  <ns2:PublicScheduledDateTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(STO/text()),'Z')"/>
                  </ns2:PublicScheduledDateTime>
                </xsl:if>
              </xsl:if>
              <xsl:if test="PUBLIC_GATE">
                <ns2:PublicGateNumber>
                  <xsl:value-of select="PUBLIC_GATE/text()" />
                </ns2:PublicGateNumber>
              </xsl:if>
              <xsl:for-each select="FIDS_MESSAGES">
                <xsl:for-each select="FIDS_MESSAGES_ROW">
                  <xsl:if test="STATUS_TEXT">
                    <ns2:StatusMessage>
                      <xsl:attribute name="RepeatIndex">
                        <xsl:value-of select="position()"/>
                      </xsl:attribute>

                      <ns2:StatusMessage>
                        <xsl:value-of select="STATUS_TEXT/text()" />
                      </ns2:StatusMessage>

                      <xsl:if test="ZONE">
                        <ns2:AirportZone>
                          <xsl:value-of select="ZONE/text()" />
                        </ns2:AirportZone>
                      </xsl:if>
                      <ns2:AirSideFlag>true</ns2:AirSideFlag>
                      <xsl:if test="UPDT_AT">
                        <ns2:UpdatedTime>
                          <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(UPDT_AT/text()),'Z')"/>
                        </ns2:UpdatedTime>
                      </xsl:if>
                      <xsl:if test="REASON">
                        <ns2:UpdateReason>
                          <xsl:value-of select="REASON/text()" />
                        </ns2:UpdateReason>
                      </xsl:if>
                      <xsl:if test="REASON_CAT">
                        <ns2:UpdateReasonCategory>
                          <xsl:value-of select="REASON_CAT/text()" />
                        </ns2:UpdateReasonCategory>
                      </xsl:if>
                      <xsl:if test="REC_NO">
                        <ns2:UpdateRecNo>
                          <xsl:value-of select="REC_NO/text()" />
                        </ns2:UpdateRecNo>
                      </xsl:if>
                    </ns2:StatusMessage>
                  </xsl:if>
                </xsl:for-each>
              </xsl:for-each>
            </ns2:PublicDisplayData>
            <xsl:if test="DEICE_FLG">
              <ns2:DeicingData>
                <ns2:OnStandDeicing>
                  <xsl:value-of select="DEICE_FLG/text()" />
                </ns2:OnStandDeicing>
                <xsl:if test="DEICE_TYPE">
                  <ns2:TypeOfDeicing>
                    <xsl:value-of select="DEICE_TYPE/text()" />
                  </ns2:TypeOfDeicing>
                </xsl:if>
                <ns2:RemoteDeicingFlag>
                  <xsl:value-of select="DEICE_FLG/text()" />
                </ns2:RemoteDeicingFlag>
                <!--<xsl:if test="DEICE_REMOTE_PAD">-->
                <ns2:RemoteDeicingLocation>
                  <xsl:value-of select="DEICE_REMOTE_PAD/text()" />
                </ns2:RemoteDeicingLocation>
                <!--</xsl:if>-->
                <xsl:choose>
                  <xsl:when test="string-length(EDIT_DUR)&gt;0 and string(number(EDIT_DUR))!='NaN'">
                    <ns2:EDIT>
                      <xsl:value-of select="number(EDIT_DUR/text() * 60)" />
                    </ns2:EDIT>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="ECZT and EEZT">
                      <ns2:EDIT>
                        <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(EEZT/text(), ECZT/text())" />
                      </ns2:EDIT>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>


                <xsl:if test="DEICE_END_TM and DEICE_START_TM">
                  <ns2:ADIT>
                    <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(DEICE_START_TM/text()),string(DEICE_END_TM/text()))"/>
                  </ns2:ADIT>
                </xsl:if>
                <xsl:if test="ERZT">
                  <ns2:ERZT>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(ERZT/text()),'Z')"/>
                  </ns2:ERZT>
                </xsl:if>
                <xsl:if test="ECZT">
                  <ns2:ECZT>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(ECZT/text()),'Z')"/>
                  </ns2:ECZT>
                </xsl:if>
                <xsl:if test="EEZT">
                  <ns2:EEZT>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(EEZT/text()),'Z')"/>
                  </ns2:EEZT>
                </xsl:if>
                <xsl:if test="DEICE_READY_TM">
                  <ns2:ERZT>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(DEICE_READY_TM/text()),'Z')"/>
                  </ns2:ERZT>
                </xsl:if>
                <xsl:if test="DEICE_START_TM">
                  <ns2:ACZT>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(DEICE_START_TM/text()),'Z')"/>
                  </ns2:ACZT>
                </xsl:if>
                <xsl:if test="DEICE_END_TM">
                  <ns2:AEZT>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(DEICE_END_TM/text()),'Z')"/>
                  </ns2:AEZT>
                </xsl:if>
              </ns2:DeicingData>
            </xsl:if>
            <ns2:ExtensionFields>
              <xsl:if test="PAX_CHILDREN">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXChildrenCount</xsl:attribute>
                  <xsl:value-of select="PAX_CHILDREN/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_MALE">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXMaleCount</xsl:attribute>
                  <xsl:value-of select="PAX_MALE/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_FEMALE">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXFemaleCount</xsl:attribute>
                  <xsl:value-of select="PAX_FEMALE/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_INFANTS">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXinfantsCount</xsl:attribute>
                  <xsl:value-of select="PAX_INFANTS/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_TRANSIT_UNACC">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXTransitUnacMinors</xsl:attribute>
                  <xsl:value-of select="PAX_TRANSIT_UNACC/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_UNACC_MINORS">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXUnaccMinorsCount</xsl:attribute>
                  <xsl:value-of select="PAX_UNACC_MINORS/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_VIP">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXVIPCount</xsl:attribute>
                  <xsl:value-of select="PAX_VIP/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="WHEELCHAIR_NO">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXWheelchairCount</xsl:attribute>
                  <xsl:value-of select="WHEELCHAIR_NO/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_DISEMBARK1">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXDisembark1Count</xsl:attribute>
                  <xsl:value-of select="PAX_DISEMBARK1/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_DISEMBARK2">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXDisembark2Count</xsl:attribute>
                  <xsl:value-of select="PAX_DISEMBARK2/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_DISEMBARK3">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXDisembark3Count</xsl:attribute>
                  <xsl:value-of select="PAX_DISEMBARK3/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_DISEMBARK4">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXDisembark4Count</xsl:attribute>
                  <xsl:value-of select="PAX_DISEMBARK4/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_LOC1">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXLocation1</xsl:attribute>
                  <xsl:value-of select="PAX_LOC1/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_LOC2">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXLocation2</xsl:attribute>
                  <xsl:value-of select="PAX_LOC2/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_LOC3">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXLocation3</xsl:attribute>
                  <xsl:value-of select="PAX_LOC3/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_LOC4">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXLocation4</xsl:attribute>
                  <xsl:value-of select="PAX_LOC4/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_LOC5">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXLocation5</xsl:attribute>
                  <xsl:value-of select="PAX_LOC5/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="PAX_LOC6">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXLocation6</xsl:attribute>
                  <xsl:value-of select="PAX_LOC6/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>
              <xsl:if test="SHARE_PAX">
                <ns2:ExtensionInteger>
                  <xsl:attribute name="Name">PAXTotalCodeShare</xsl:attribute>
                  <xsl:value-of select="SHARE_PAX/text()" />
                </ns2:ExtensionInteger>
              </xsl:if>

              <xsl:if test="ADM_CAR_DELIM">
                <ns2:ExtensionFlag>
                  <xsl:attribute name="Name">DoNotSequenceFlag</xsl:attribute>
                  <xsl:value-of select="ADM_CAR_DELIM/text()" />
                </ns2:ExtensionFlag>
              </xsl:if>
              <xsl:if test="DEICE_REQUIRED">
                <ns2:ExtensionFlag>
                  <xsl:attribute name="Name">NeedsDecingFlag</xsl:attribute>
                  <xsl:value-of select="DEICE_REQUIRED/text()" />
                </ns2:ExtensionFlag>
              </xsl:if>
              <xsl:if test="CABIN_RELEASED">
                <ns2:ExtensionFlag>
                  <xsl:attribute name="Name">CabinReleased</xsl:attribute>
                  <xsl:value-of select="CABIN_RELEASED/text()" />
                </ns2:ExtensionFlag>
              </xsl:if>

              <xsl:if test="TOBT2">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">TOBTatAIBT</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(TOBT2/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="TOBT1">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">TOBTatApproach</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(TOBT1/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="TOBT_REPORT">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">TOBTatReportLimit</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(TOBT_REPORT/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="FIRST_BAG">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">FirstBagReclaim</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(FIRST_BAG/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="LAST_BAG">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">LastBagReclaim</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(LAST_BAG/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="BD_START_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">ScheduleFirstPAXonAC</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(BD_START_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="BD_END_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">ScheduleLastPAXonAC</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(BD_END_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="FIRST_PAX_ACRFT">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">FirstPAXonOffAC</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(FIRST_PAX_ACRFT/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="PUSH_CLEARANCE_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">ActualPushClearance</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(PUSH_CLEARANCE_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="CATER_START_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">CaterStartTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(CATER_START_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="CATER_END_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">CaterEndTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(CATER_END_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="APPROACH_EIBT">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">EIBTonApproach</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(APPROACH_EIBT/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="REFUEL_END_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">RefuelEndTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(REFUEL_END_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="REFUEL_START_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">RefuelStartTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(REFUEL_START_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="CLEAN_START_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">CleaningStartTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(CLEAN_START_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="CLEAN_END_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">CleaningEndTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(CLEAN_END_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="RWAY_ENTRY">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">RunwayEntryTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(RWAY_ENTRY/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="RWAY_EXIT">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">RunwayExitTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(RWAY_EXIT/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>

              <xsl:if test="RUNWAY_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">RunwayLineUpTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(RUNWAY_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>

              <xsl:if test="FIRST_GATE_BAG_ACRFT">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">FirstGateBagOnAC</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(FIRST_GATE_BAG_ACRFT/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="LAST_GATE_BAG_ACRFT">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">LastGateBagOnAC</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(LAST_GATE_BAG_ACRFT/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
              <xsl:if test="DEICE_RIG_TM">
                <ns2:ExtensionDateTime>
                  <xsl:attribute name="Name">DeiceRigOnStandTime</xsl:attribute>
                  <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(DEICE_RIG_TM/text()),'Z')" />
                </ns2:ExtensionDateTime>
              </xsl:if>
            </ns2:ExtensionFields>
            <xsl:if test="REMOTE_HOLD">
              <ns2:RemoteHoldData>
                <xsl:choose>
                  <xsl:when test="HOLD_REJECT_CODE">
                    <xsl:attribute name="RemoteHoldAcceptOrRejectFlag">true</xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="RemoteHoldAcceptOrRejectFlag">false</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:attribute name="RemoteHoldIndicator">
                  <xsl:value-of select="REMOTE_HOLD/text()" />
                </xsl:attribute>
                <xsl:if test="REMOTE_HOLD_EXIT_TM and REMOTE_HOLD_ENTRY_TM">
                  <xsl:variable name="var:RemoteHoldDuration" select="ScriptNS0:GetTimeDifferenceSecs(string(REMOTE_HOLD_EXIT_TM/text()),string(REMOTE_HOLD_ENTRY_TM/text()))" />
                  <xsl:if test="$var:RemoteHoldDuration != 0">
                    <ns2:RemoteHoldDuration>
                      <xsl:value-of select="ScriptNS0:GetTimeDifferenceSecs(string(REMOTE_HOLD_EXIT_TM/text()),string(REMOTE_HOLD_ENTRY_TM/text()))"/>
                    </ns2:RemoteHoldDuration>
                  </xsl:if>
                </xsl:if>
                <xsl:if test="REMOTE_HOLD_AREA">
                  <ns2:RemoteHoldLocation>
                    <xsl:value-of select="REMOTE_HOLD_AREA/text()" />
                  </ns2:RemoteHoldLocation>
                </xsl:if>
                <xsl:if test="PLAN_HOLD_AREA">
                  <ns2:RemoteHoldPlannedLocation>
                    <xsl:value-of select="PLAN_HOLD_AREA/text()" />
                  </ns2:RemoteHoldPlannedLocation>
                </xsl:if>
                <xsl:if test="HOLD_REJECT_CODE">
                  <ns2:RemoteHoldRejectReason>
                    <xsl:value-of select="HOLD_REJECT_CODE/text()" />
                  </ns2:RemoteHoldRejectReason>
                </xsl:if>
                <xsl:if test="REM_EXOT">
                  <ns2:RemoteHoldEXOT>
                    <xsl:value-of select="REM_EXOT/text()" />
                  </ns2:RemoteHoldEXOT>
                </xsl:if>
                <xsl:if test="REMOTE_HOLD_EXIT_TM">
                  <ns2:RemoteHoldOffBlockTime>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(REMOTE_HOLD_EXIT_TM/text()),'Z')"/>
                  </ns2:RemoteHoldOffBlockTime>
                </xsl:if>
                <xsl:if test="REMOTE_HOLD_ENTRY_TM">
                  <ns2:EnterRemoteHold>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(REMOTE_HOLD_ENTRY_TM/text()),'Z')"/>
                  </ns2:EnterRemoteHold>
                </xsl:if>
                <xsl:if test="REMOTE_HOLD_EXIT_TM">
                  <ns2:ExitRemoteHold>
                    <xsl:value-of select="ScriptNS0:FormatOracleDateTime(string(REMOTE_HOLD_EXIT_TM/text()),'Z')"/>
                  </ns2:ExitRemoteHold>
                </xsl:if>
              </ns2:RemoteHoldData>
            </xsl:if>
          </ns0:TPA_Extension>
        </ns0:FlightLeg>
      </xsl:for-each>
    </ns0:IATA_AIDX_FlightLegNotifRQ>
  </xsl:template>
 <msxsl:script language="C#" implements-prefix="userCSharp">
    <![CDATA[
  
public int optimeindex = 0;
public int remarkIndex = 0;
public int osIndex = 0;
public int flsIndex = 0;
public int delayIndex = 0;
public int aflsIndex = 0;
public int csIndex = 0;
public int delayIndex2 = 0;

public int GetNextDelayIndex2()
{
  delayIndex2++;
  return delayIndex2;
}

public int GetNextCSIndex()
{
  csIndex++;
  return csIndex;
}


public int GetNextAFLSIndex()
{
  aflsIndex++;
  return aflsIndex;
}

public int GetNextDelayIndex()
{
  delayIndex++;
  return delayIndex;
}
public int GetNextRemarkIndex()
{
  remarkIndex++;
  return remarkIndex;
}

public int GetNextFLSIndex()
{
  flsIndex++;
  return flsIndex;
}

public int GetNextOSIndex()
{
  osIndex++;
  return osIndex;
}

public void ResetIndexes()
{
  remarkIndex = 0;
  optimeindex = 0;
  osIndex = 0;
  flsIndex = 0;
  delayIndex = 0;
  aflsIndex = 0;
}

public int GetNextOpTimeIndex()
{
  optimeindex++;
  return optimeindex;
}
public bool LogicalEq(string val1, string val2)
{
	bool ret = false;
	double d1 = 0;
	double d2 = 0;
	if (IsNumeric(val1, ref d1) && IsNumeric(val2, ref d2))
	{
		ret = d1 == d2;
	}
	else
	{
		ret = String.Compare(val1, val2, StringComparison.Ordinal) == 0;
	}
	return ret;
}


public string StringConcat(string param0)
{
   return param0;
}


public bool LogicalExistence(bool val)
{
	return val;
}


public bool LogicalNot(string val)
{
	return !ValToBool(val);
}


public bool LogicalAnd(string param0, string param1)
{
	return ValToBool(param0) && ValToBool(param1);
	return false;
}


public bool LogicalOr(string param0, string param1)
{
	return ValToBool(param0) || ValToBool(param1);
	return false;
}

public string MathSubtract(string param0, string param1)
{
	System.Collections.ArrayList listValues = new System.Collections.ArrayList();
	listValues.Add(param0);
	listValues.Add(param1);
	double ret = 0;
	bool first = true;
	foreach (string obj in listValues)
	{
		if (first)
		{
			first = false;
			double d = 0;
			if (IsNumeric(obj, ref d))
			{
				ret = d;
			}
			else
			{
				return "";
			}
		}
		else
		{
			double d = 0;
			if (IsNumeric(obj, ref d))
			{
				ret -= d;
			}
			else
			{
				return "";
			}
		}
	}
	return ret.ToString(System.Globalization.CultureInfo.InvariantCulture);
}

public string MathAdd(string param0, string param1)
{
	System.Collections.ArrayList listValues = new System.Collections.ArrayList();
	listValues.Add(param0);
	listValues.Add(param1);
	double ret = 0;
	foreach (string obj in listValues)
	{
	double d = 0;
		if (IsNumeric(obj, ref d))
		{
			ret += d;
		}
		else
		{
			return "";
		}
	}
	return ret.ToString(System.Globalization.CultureInfo.InvariantCulture);
}


public bool IsNumeric(string val)
{
	if (val == null)
	{
		return false;
	}
	double d = 0;
	return Double.TryParse(val, System.Globalization.NumberStyles.AllowThousands | System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d);
}

public bool IsNumeric(string val, ref double d)
{
	if (val == null)
	{
		return false;
	}
	return Double.TryParse(val, System.Globalization.NumberStyles.AllowThousands | System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d);
}

public bool ValToBool(string val)
{
	if (val != null)
	{
		if (string.Compare(val, bool.TrueString, StringComparison.OrdinalIgnoreCase) == 0)
		{
			return true;
		}
		if (string.Compare(val, bool.FalseString, StringComparison.OrdinalIgnoreCase) == 0)
		{
			return false;
		}
		val = val.Trim();
		if (string.Compare(val, bool.TrueString, StringComparison.OrdinalIgnoreCase) == 0)
		{
			return true;
		}
		if (string.Compare(val, bool.FalseString, StringComparison.OrdinalIgnoreCase) == 0)
		{
			return false;
		}
		double d = 0;
		if (IsNumeric(val, ref d))
		{
			return (d > 0);
		}
	}
	return false;
}

public string ReplaceFlightNo( string flyt_no, string quebec )
{
    if( quebec != "" )
    {
    return flyt_no.Replace( quebec, ""); 
    }
    else
    {
    return flyt_no;
    }
}


]]>
  </msxsl:script>

</xsl:stylesheet>