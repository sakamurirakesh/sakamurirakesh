<?xml version="1.0" encoding="UTF-8"?>
<!--
Layout Rewe Deutschland
- 4.3" Labels (Wein + Backwaren + Normal)
- 4.2" Labels für Obst und Gemüse
- 2.9" M2 + M3 Normal und mit Pfandkennzeichnung
- 2.6" M3 Labels Normal und mit Pfandkennzeichnung
- 1.6" M2 + M3 Labels

Andreas Thust SoluM Europe GmbH
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon" >
	<xsl:output encoding="UTF-8" />
	<xsl:decimal-format name="noNAN" NaN="" />
	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" font-family="Frutiger 57Cn" font-weight="bold">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="only">
					<xsl:attribute name="page-width"><xsl:value-of select="/LISTE/WIDTH" /></xsl:attribute>
					<xsl:attribute name="page-height"><xsl:value-of select="/LISTE/HEIGHT" /></xsl:attribute>
					<xsl:if test="/LISTE/WIDTH = 152 and /LISTE/HEIGHT = 152">
						<xsl:attribute name="reference-orientation">270</xsl:attribute>
					</xsl:if>
					<fo:region-body region-name="xsl-region-body" />
				</fo:simple-page-master>
			</fo:layout-master-set>
			<xsl:for-each select="LISTE/SEITE/ARTIKEL">
				<fo:page-sequence master-reference="only">
					<fo:flow flow-name="xsl-region-body">
					    <xsl:choose>
						<xsl:when test="/LISTE/WIDTH = 152 and /LISTE/HEIGHT = 152">
							<xsl:call-template name="ETIKETT16_M2" />
						</xsl:when>
						<xsl:when test="/LISTE/WIDTH = 296 and /LISTE/HEIGHT = 128">
							<xsl:call-template name="ETIKETT29_M2" />
						</xsl:when>
						<xsl:when test="/LISTE/WIDTH = 200 and /LISTE/HEIGHT = 200">
							<xsl:call-template name="ETIKETT16" />
						</xsl:when>
						<xsl:when test="/LISTE/WIDTH = 384 and /LISTE/HEIGHT = 168">
							<xsl:call-template name="ETIKETT29" />
						</xsl:when>
						<xsl:when test="/LISTE/WIDTH = 360 and /LISTE/HEIGHT = 184">
							<xsl:call-template name="ETIKETT26" />
						</xsl:when>
						<xsl:when test="/LISTE/WIDTH = 522 and /LISTE/HEIGHT = 152">
							<xsl:call-template name="ETIKETT43" />
						</xsl:when>
						<xsl:when test="/LISTE/WIDTH = 400 and /LISTE/HEIGHT = 300">
							<xsl:call-template name="ETIKETT42" />
						</xsl:when>
						</xsl:choose>
					</fo:flow>
				</fo:page-sequence>
			</xsl:for-each>
		</fo:root>
	</xsl:template>
	
	<xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
	
	

     <!-- Layout für 2.9" M2 Etiketten -->
	<xsl:template name="ETIKETT29_M2">
		<xsl:variable name="isAktion" select="@versTextZahl = 'A'" />
		<xsl:variable name="isBottle" select="@leergutKz = 'P' or @leergutKz = 'B'" />
		<xsl:variable name="isMehrweg" select="@leergutKz = 'B'" />
		<xsl:variable name="isMehrwegUndAktion" select="@leergutKz = 'B' and (@versTextZahl = 'A' or @schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0) " />
		<xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'" />
		<xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
		<xsl:variable name="isDreherOrRaemung" select="@schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0 "/>
		<xsl:variable name="containsEAN" select="string-length(@ean) &gt; 0"/>
		<xsl:variable name="hasNoBarcode" select="string-length(@barcode) &lt; 1"/>
		<xsl:variable name="hasLeergut" select="string-length(@leergutPreis) &gt; 0"/>

		<xsl:variable name="text1and2">
	    <xsl:value-of select="@artikeltext1" /><xsl:text> </xsl:text><xsl:value-of select="@artikeltext2" />
		</xsl:variable>
		
		<xsl:variable name="text1and2FontSize">
		  <xsl:choose>
		    <xsl:when test="string-length($text1and2) &gt; 37">13</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 33">15</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 28">17</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 22">19</xsl:when>
		    <xsl:otherwise>21</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
	
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<fo:block-container position="absolute" left="0px" top="0px" width="296px" height="128px" background-color="{$bckColor}" text-align="center" line-height="21px" font-size="20pt" font-weight="bold" >	
			<fo:block></fo:block>	
	    </fo:block-container>

		<!-- Aktionsbalken -->
		<xsl:if test="$isAktion">
			<fo:block-container position="absolute" left="0px" top="0px" width="20px" height="128px" text-align="center" line-height="18px" font-size="19pt" font-weight="bold" font-family="Frutiger 57Cn">
				<xsl:attribute name="background-color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$bckColor" /></xsl:attribute>
				<fo:block margin-top="15px" >A</fo:block>
				<fo:block >K</fo:block>
				<fo:block >T</fo:block>
				<fo:block >I</fo:block>
				<fo:block >O</fo:block>
				<fo:block >N</fo:block>
			</fo:block-container>
		</xsl:if>

		<!-- Texte -->
		<fo:block-container position="absolute" top="4" font-family="Frutiger 57Cn" font-size="18pt" font-weight="bold">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 2" />px</xsl:attribute>
			<!-- Text 1 / Text 2 -->
			<!-- Der Text darf nicht brechen, da er sonst mit dem Grundpreis ueberlappen wuerde. -->
			<!-- Daher wird die maximale Schriftgroesse berechnet. -->
			<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute>
				<xsl:value-of select="$text1and2" />
			</fo:block>
			<!-- Text 3 -->
			<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext3" />
			</fo:block>
			<!-- Inhaltsangabe -->
			<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@inhaltsangabe" />
			</fo:block>
			<!-- Pfand -->
			<xsl:if test="@leergutPreis!=''" >
				<fo:block line-height="1em" wrap-option="no-wrap" >

				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					+ Pfand <xsl:value-of select="format-number(@leergutPreis, '##0.00')" />
				</fo:block>
			</xsl:if>
		</fo:block-container>
		
		<xsl:choose>
		  <xsl:when test="$isPage2">
			<fo:block-container position="absolute" font-family="Frutiger 57Cn" font-size="15pt" font-weight="bold" line-height="0.9em" top="68px">			   
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 2" />px</xsl:attribute>
								
				<fo:block>
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@nan" />
				</fo:block>
							
				<fo:block>
				    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="@lagerLieferant" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
				
				<!--
				<fo:block>				
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				  <xsl:value-of select="@ean" />
				</fo:block>	
				-->
			</fo:block-container>
		</xsl:when>
		<xsl:otherwise>
			<!-- Grundpreis -->
				<fo:block-container position="absolute" font-family="Frutiger 57Cn" font-size="18px" font-weight="bold">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 2" />px</xsl:attribute>
					<xsl:attribute name="top"><xsl:value-of select="46 + $hasLeergut * 18" />px</xsl:attribute>
					
					<fo:block >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
	
					<xsl:choose>
					<xsl:when test="$isPage2">
					<!-- EAN -->
						<xsl:value-of select="@ean" />
					</xsl:when>
					<xsl:when test="@grundPreisPOF != ''">
						<!-- Grundpreis -->
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					</xsl:choose>
					
					</fo:block>
				</fo:block-container>
		</xsl:otherwise>
		</xsl:choose>

		<!-- Nutriscore -->		
		<xsl:if test="$isNutriScore and not($isBottle)">
			<xsl:choose>
				<xsl:when test="$isPage2">
				</xsl:when>
				<xsl:otherwise>
					<fo:block-container position="absolute" top="72px" width="108px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 3" />px</xsl:attribute>			
					
					<xsl:choose>
					<xsl:when test="$isAktion">
					<fo:block line-height="1em">
					
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					
					</fo:block>			
					</xsl:when>
					<xsl:otherwise>
					<fo:block line-height="1em">
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC	
		"/>
					</xsl:if>
					</fo:block>	
					</xsl:otherwise>
					</xsl:choose>					
					</fo:block-container>					
					
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<xsl:if test="@barcode != ''">
			<!-- Barcode intl2of5 829-->	
			<xsl:choose>
			    <!-- 2D1 281 283/ B27 01EB7D5FB27A -->
			  <xsl:when test="( /LISTE/LABELTYPE = '2D1' or /LISTE/LABELTYPE = '281' or /LISTE/LABELTYPE = '283') and $isAktion">
				<fo:block-container position="absolute" height="54px" background-color="white">
				<xsl:attribute name="width"><xsl:value-of select="132 - $isMehrweg * 25" />px</xsl:attribute>
				<xsl:attribute name="top"><xsl:value-of select="83" />px</xsl:attribute>
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20" />px</xsl:attribute>
				<fo:block></fo:block>
				</fo:block-container>
			 
				<xsl:if test="@barcode != ''">
					<fo:block-container position="absolute" width="137px" >	
					<xsl:attribute name="top"><xsl:value-of select="105"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 3"/>px</xsl:attribute>
					<fo:block line-height="0.9em">
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>10</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>	
					</fo:block-container>
				</xsl:if>
				
				<!-- Schnelldreherpunkt und R -->
				<fo:block-container position="absolute" top="99px" width="12px" background-color="white">
						<xsl:attribute name="left"><xsl:value-of select="137 - $isMehrweg * 25" />px</xsl:attribute>
						<fo:block line-height="0.9em" >
							<xsl:if test="@schnelldreher = 'true'">
							<fo:instream-foreign-object>
								<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
									<circle cx="6" cy="6" fill="black" r="6" />
								</svg>
							</fo:instream-foreign-object>	
							</xsl:if>
						</fo:block>
						
						<fo:block line-height="0.9em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold">
							<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
								R
							</xsl:if>
						</fo:block>	
				</fo:block-container>

				<fo:block-container position="absolute" width="100px" text-align="right" >
				<xsl:attribute name="top"><xsl:value-of select="85"/>px</xsl:attribute>
				<xsl:attribute name="left"><xsl:value-of select="50 - $isMehrweg * 25"/>px</xsl:attribute>
				<fo:block line-height="0.9em" font-size="17pt" >
					<xsl:value-of select="@lagerLieferant"/>
				</fo:block>
				</fo:block-container>
					
			</xsl:when>
			<xsl:otherwise>
					
				<xsl:if test="@barcode != ''">
					<fo:block-container position="absolute" width="137px" >	
					<xsl:attribute name="top"><xsl:value-of select="105"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 3"/>px</xsl:attribute>
					<fo:block line-height="0.9em">
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>10</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>	
					</fo:block-container>
				</xsl:if>
				
				<!-- Schnelldreherpunkt und R -->
				<fo:block-container position="absolute" top="99px" width="12px">
						<xsl:attribute name="left"><xsl:value-of select="137 - $isMehrweg * 25" />px</xsl:attribute>
						<fo:block line-height="0.9em">
							<xsl:if test="@schnelldreher = 'true'">
							<fo:instream-foreign-object>
								<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
									<circle cx="6" cy="6" fill="black" r="6" />
								</svg>
							</fo:instream-foreign-object>	
							</xsl:if>
						</fo:block>
						
						<fo:block line-height="0.9em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold">
							<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
								R
							</xsl:if>
						</fo:block>	
				</fo:block-container>

				<fo:block-container position="absolute" width="100px" text-align="right" >
						<xsl:attribute name="top"><xsl:value-of select="85"/>px</xsl:attribute>
						<xsl:attribute name="left"><xsl:value-of select="50 - $isMehrweg * 25"/>px</xsl:attribute>
						<fo:block line-height="0.9em" font-size="17pt" >
							<xsl:value-of select="@lagerLieferant"/>
						</fo:block>
				</fo:block-container>
	
				</xsl:otherwise>
				</xsl:choose>
				</xsl:if>				
				
				<!--
				<xsl:if test="@ean != ''">
					<fo:block-container position="absolute" top="152">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 20 + 4"/>px</xsl:attribute>
					<fo:block font-size="17pt" line-height="0.9em">
						<xsl:value-of select="@ean"/>
					</fo:block>	
					</fo:block-container>
				</xsl:if>
				-->

		<!-- Preis -->
		<xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
		<xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
		<xsl:variable name="preiseuro" select="substring-before($preis, '.')" />
		<xsl:variable name="preiscent" select="translate(substring(substring-after($preis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
		<!-- Euro-Betrag mit Punkt -->
		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="62 - $isBottle * 15 - $isFW * 30"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="35 - $isBottle * 12"/>px</xsl:attribute>
			<xsl:if test="$isAktion and not($isPage2)">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			</xsl:if>
			<fo:block font-family="REWE Preisschrift" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="72 - $isBottle * 26"/>pt</xsl:attribute>
				<!-- With Euro Sign <fo:inline font-weight="normal" font-family="Arial"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute>€</fo:inline> -->
				<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 14"/>pt</xsl:attribute></fo:inline>
				<fo:inline><xsl:value-of select="$preiseuro" />.</fo:inline>
			</fo:block>
		</fo:block-container>
		<!-- Cent-Betrag, höhergestellt -->
		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="62 - $isBottle * 15 - $isFW * 30"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="4 - $isBottle * 2"/>px</xsl:attribute>
			<xsl:if test="$isAktion and not($isPage2)">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			</xsl:if>
			<fo:block font-family="REWE Preisschrift" >

				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size" ><xsl:value-of select="72 - $isBottle * 26"/>pt</xsl:attribute>
				<xsl:value-of select="$preiscent" />
			</fo:block>
		</fo:block-container>
		
		
		<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwpreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwpreiseuro" select="substring-before($fwpreis, '.')" />
			<xsl:variable name="fwpreiscent" select="translate(substring(substring-after($fwpreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<!-- Euro-Betrag mit Punkt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="90 - $isBottle * 35"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="18"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>		
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="38"/>pt</xsl:attribute>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="22"/>pt</xsl:attribute><xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/></fo:inline>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute></fo:inline>
					<fo:inline><xsl:value-of select="$fwpreiseuro" />.</fo:inline>
				</fo:block>
			</fo:block-container>
			<!-- Cent-Betrag, höhergestellt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="90 - $isBottle * 35"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="2"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size" ><xsl:value-of select="38"/>pt</xsl:attribute>
					<xsl:value-of select="$fwpreiscent" />
				</fo:block>
			</fo:block-container>
		</xsl:if>
		
		<!-- Pfandangabe Einweg / Mehrweg -->
		<xsl:if test="$isBottle">
			<fo:block-container position="absolute" top="89px" text-align="right" font-family="Frutiger 57Cn" font-size="39pt" font-weight="bold" color="#ffffff">
				<xsl:attribute name="left"><xsl:value-of select="146 + $isAktion * 20"/>px</xsl:attribute>
				<fo:block >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:choose><xsl:when test="@leergutKz = 'B'">
						<xsl:attribute name="letter-spacing">-2pt</xsl:attribute>
						MEHRWEG
					</xsl:when><xsl:when test="@leergutKz = 'P'">
						EINWEG
					</xsl:when></xsl:choose>
				</fo:block>
			</fo:block-container>
		</xsl:if>
	</xsl:template>





	<!-- Template für 1.6" Etiketten M2 -->
	<xsl:template name="ETIKETT16_M2">
		<xsl:variable name="isAktion" select="@versTextZahl = 'A'"/>
		<xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'"/>
		<xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
		<xsl:variable name="isDreherOrRaemung" select="@schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0 "/>
		
		<!-- Preis -->
		<xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
		<xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
		<xsl:variable name="preiseuro" select="substring-before($preis, '.')" />
		<xsl:variable name="preiscent" select="translate(substring(substring-after($preis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />

		<xsl:variable name="text1and2">
		    <xsl:choose>
			<xsl:when test="@artikeltext1 != ''">
	          <xsl:value-of select="substring(@artikeltext1, 1, 32)" />
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="substring(@artikeltext2, 1, 32)" />
			</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="text1and2FontSize">
		  <xsl:choose>
			<xsl:when test="string-length($text1and2) &gt; 30">16</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 25">17</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 20">18</xsl:when>
		    <xsl:otherwise>19</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<fo:block-container position="absolute" left="0px" top="0px" width="152px" height="152px" background-color="{$bckColor}" text-align="center" line-height="21px" font-size="20pt" >
			<fo:block></fo:block>	
	    </fo:block-container>

		<xsl:choose>
		 <xsl:when test="(/LISTE/LABELTYPE = '141' or /LISTE/LABELTYPE = '143' or /LISTE/LABELTYPE = 'A01') and $isAktion">
			<fo:block-container position="absolute" top="80px" width="67px" height="54px" background-color="white">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18" />px</xsl:attribute>
			<fo:block></fo:block>
			</fo:block-container>
			
			<fo:block-container position="absolute" top="124px" left="139px" height="27px" width="13px" background-color="white">
			<fo:block></fo:block>
			</fo:block-container>
			
		  </xsl:when>
		</xsl:choose>

		<!-- Aktionsbalken -->
		<xsl:if test="$isAktion">
			<fo:block-container position="absolute" left="0px" top="0px" width="18px" height="152px" text-align="center" line-height="18px" font-size="18pt" font-weight="bold" >
				<xsl:attribute name="background-color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$bckColor"/></xsl:attribute>	
				<fo:block margin-top="22px">A</fo:block>
				<fo:block>K</fo:block>
				<fo:block>T</fo:block>
				<fo:block>I</fo:block>
				<fo:block>O</fo:block>
				<fo:block>N</fo:block>
			</fo:block-container>
		</xsl:if>

		<!-- Nutriscore -->		
		<xsl:choose>
		<xsl:when test="$isNutriScore and not($isPage2)">
			<fo:block-container position="absolute" top="68px" width="108px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 2" />px</xsl:attribute>
			
			<xsl:choose>
					<xsl:when test="$isAktion">
					<fo:block line-height="1em">
	
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					</fo:block>			
					</xsl:when>
					
					<xsl:otherwise>
					<fo:block line-height="1em">
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					</fo:block>	
					</xsl:otherwise>
					</xsl:choose>
			</fo:block-container>
			
			<!-- Schnelldreherpunkt und R -->
			<fo:block-container position="absolute" top="124px" left="139px" width="10px" color="black">
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<fo:block>
				<xsl:if test="@schnelldreher = 'true'">
					<fo:instream-foreign-object>
					<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="10px" width="10px" xml:space="preserve">
						<circle cx="6" cy="6" fill="black" r="6" />
					</svg>
					</fo:instream-foreign-object>	
				</xsl:if>
			</fo:block>
			
			<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="16pt" color="black">
			<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
				R
			</xsl:if>
			</fo:block>
			</fo:block-container>

			<xsl:if test="string-length(@lagerLieferant) &gt; 0">
				<fo:block-container position="absolute" top="98px" color="black">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 2 " />px</xsl:attribute>
				<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="16pt" font-weight="bold" color="black">
					<xsl:value-of select="@lagerLieferant"/>
				</fo:block>	
				</fo:block-container>
			</xsl:if>	
		</xsl:when>

		<xsl:otherwise>
			<!-- Schnelldreherpunkt und R -->
			<fo:block-container position="absolute" top="124px" left="139px" width="10px" color="black">
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<fo:block>
				<xsl:if test="@schnelldreher = 'true'">
					<fo:instream-foreign-object>
					<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="10px" width="10px" xml:space="preserve">
						<circle cx="6" cy="6" fill="black" r="6" />
					</svg>
					</fo:instream-foreign-object>	
				</xsl:if>
			</fo:block>
			
			<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="16pt" color="black">
			<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
				R
			</xsl:if>
			</fo:block>
			</fo:block-container>

			<xsl:if test="string-length(@lagerLieferant) &gt; 0">
				<fo:block-container position="absolute" top="96px" color="black">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 2 " />px</xsl:attribute>
				<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="16pt" font-weight="bold" color="black">
					<xsl:value-of select="@lagerLieferant"/>
				</fo:block>	
				</fo:block-container>
			</xsl:if>
	
		</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
		<xsl:when test="string-length($preiseuro) &gt; 1 or $isAktion">
			<xsl:if test="@barcode != ''">
				<fo:block-container position="absolute" top="115px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 1"/>px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>8</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>2</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</xsl:if>	
			<!--
			<xsl:if test="@ean != ''">
				<fo:block-container position="absolute" top="108px">	
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 3" />px</xsl:attribute>
					  <fo:block font-size="17pt">
				      <xsl:value-of select="@ean"/>
					  </fo:block>
				</fo:block-container>	
			</xsl:if>
			-->
			
		</xsl:when>
		<xsl:otherwise>
			<xsl:if test="@barcode != ''">
				<fo:block-container position="absolute" top="115px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 1" />px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>8</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</xsl:if>
			<!--
			<xsl:if test="@ean != ''">
				<fo:block-container position="absolute" top="108px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 3"/>px</xsl:attribute>
					  <fo:block font-size="17pt">
				      <xsl:value-of select="@ean"/>
					  </fo:block>
				</fo:block-container>
			</xsl:if>
			-->
					
		</xsl:otherwise>
		</xsl:choose>

		<!-- Inhaltsangabe -->
		<!-- <fo:block-container position="absolute" top="185" left="3">
			<fo:block font-size="12pt" font-weight="700">
				<xsl:value-of select="@inhaltsangabe" />
			</fo:block>
		</fo:block-container> -->

		<!-- Texte -->
		<fo:block-container position="absolute" top="4px" right="0px" font-family="Frutiger 57Cn" font-weight="bold">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 1" />px</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>  
			<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute>
			
			<!-- Text 1 / Text 2 -->
			<!-- Der Text darf umbrechen. -->
			<fo:block line-height="0.94em" wrap-option="wrap">
				<xsl:value-of select="@artikeltext1" />
			</fo:block>
			<xsl:choose>
			<xsl:when test="$isPage2">
				<!-- Text 3, etwas kleiner -->
				<fo:block font-size="19pt"  line-height="1em" wrap-option="no-wrap">	
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext3" /></fo:block>
				<fo:block font-size="19pt" line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />&#160;
					<xsl:value-of select="@lagerLieferant" />
				</fo:block>
				<fo:block font-size="19pt" line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- Inhaltsangabe (Text 4, ist Kurzfassung) -->
				<fo:block line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext3" />
				</fo:block>
				<fo:block line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext4" />
				</fo:block>
			</xsl:otherwise></xsl:choose>
		</fo:block-container>
	
		<!-- Vorkommastelle mit Trennzeichen und Währung -->
		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="83 - $isFW * 36"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="27"/>px</xsl:attribute>
			<fo:block font-family="REWE Preisschrift">
			    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="55"/>pt</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:inline><xsl:value-of select="$preiseuro"/>.</fo:inline>
			</fo:block>
		</fo:block-container>
		<!-- Nachkommastelle -->
		<fo:block-container position="absolute">
			<xsl:attribute name="top"><xsl:value-of select="83 - $isFW * 36"/>px</xsl:attribute>
			<xsl:attribute name="left"><xsl:value-of select="112"/>px</xsl:attribute>
			<fo:block font-family="REWE Preisschrift">
			    <xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="55 "/>pt</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:inline><xsl:value-of select="$preiscent"/></fo:inline>
			</fo:block>
		</fo:block-container>

		<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwpreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwpreiseuro" select="substring-before($fwpreis, '.')" />
			<xsl:variable name="fwpreiscent" select="translate(substring(substring-after($fwpreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<!-- Euro-Betrag mit Punkt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="107 - $isFW *13"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="15"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>		
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="30"/>pt</xsl:attribute>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn" vertical-align="text-top"><xsl:attribute name="font-size"><xsl:value-of select="16"/>pt</xsl:attribute><xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/></fo:inline>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46"/>pt</xsl:attribute></fo:inline>
					<fo:inline><xsl:value-of select="$fwpreiseuro" />.</fo:inline>
				</fo:block>
			</fo:block-container>
			<!-- Cent-Betrag, höhergestellt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="107 - $isFW *13"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="2"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size" ><xsl:value-of select="30"/>pt</xsl:attribute>
					<xsl:value-of select="$fwpreiscent" />
				</fo:block>
			</fo:block-container>
		</xsl:if>

		<!-- Fußzeile -->
		<!-- <xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute> -->
		<fo:block-container position="absolute"  font-family="Frutiger 57Cn"  font-size="17pt" font-weight="bold" top="132px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 18 + 2" />px</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			
			<fo:block wrap-option="no-wrap"> 
				<xsl:choose>
				<xsl:when test="$isPage2">
					<!-- NaN -->
					<xsl:value-of select="@nan" />
				</xsl:when>
				<xsl:when test="@grundPreisPOF != ''">
					<!-- Grundpreis -->
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
				</xsl:choose>
			</fo:block>
		</fo:block-container>
	</xsl:template>
	
	
	
	<!-- Template für 1.6" Etiketten Newton -->
	<xsl:template name="ETIKETT16">
		<xsl:variable name="isAktion" select="@versTextZahl = 'A'"/>
		<xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'"/>
		<xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
		<xsl:variable name="isDreherOrRaemung" select="@schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0 "/>
		<xsl:variable name="isBottle" select="@leergutKz = 'P' or @leergutKz = 'B'" />
		
		<!-- Preis -->
		<xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
		<xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
		<xsl:variable name="preiseuro" select="substring-before($preis, '.')" />
		<xsl:variable name="preiscent" select="translate(substring(substring-after($preis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
		<xsl:variable name="preiseuro2Digits" select="string-length($preiseuro) &gt; 1" />

		<xsl:variable name="text1and2_tmp1">
	      <xsl:value-of select="@artikeltext1"/><xsl:text> </xsl:text><xsl:value-of select="@artikeltext2" /> 
		</xsl:variable>
		<xsl:variable name="text1and2_tmp2">
	      <xsl:value-of select="substring($text1and2_tmp1, 1, 72)" />
		</xsl:variable>
		<!-- 		
		-->		
		<xsl:variable name="text1and2">
          <xsl:call-template name="replace-string">
		    <xsl:with-param name="text" select="$text1and2_tmp2"/>
            <xsl:with-param name="replace" select="'.'" />
            <xsl:with-param name="with" select="'. '"/>
          </xsl:call-template>		  
        </xsl:variable>

	
		<xsl:variable name="text1and2FontSize">
		<xsl:choose>
		    <xsl:when test="$isAktion">	
				  <xsl:choose>
				    <xsl:when test="string-length($text1and2) &gt; 43">16</xsl:when>
				    <xsl:when test="string-length($text1and2) &gt; 28">18</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 23">21</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 19">22</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 16">23</xsl:when>
					<xsl:otherwise>24</xsl:otherwise>
				  </xsl:choose>
			</xsl:when>
		    <xsl:otherwise>			
				  <xsl:choose>
				    <xsl:when test="string-length($text1and2) &gt; 47">16</xsl:when>
				    <xsl:when test="string-length($text1and2) &gt; 30">18</xsl:when>
				    <xsl:when test="string-length($text1and2) &gt; 28">21</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 23">22</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 18">23</xsl:when>
					<xsl:otherwise>24</xsl:otherwise>
				  </xsl:choose>	
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<fo:block-container position="absolute" left="0px" top="0px" width="200px" height="200px" background-color="{$bckColor}" text-align="center" line-height="21px" font-size="20pt" >
			<fo:block></fo:block>	
	    </fo:block-container>

		<!-- Aktionsbalken -->
		<xsl:if test="$isAktion">
			<fo:block-container position="absolute" left="0px" top="0px" width="25px" height="200px" text-align="center" line-height="21px" font-size="21pt" font-weight="bold" >
				<xsl:attribute name="background-color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$bckColor"/></xsl:attribute>	
				<fo:block margin-top="42px">A</fo:block>
				<fo:block>K</fo:block>
				<fo:block>T</fo:block>
				<fo:block>I</fo:block>
				<fo:block>O</fo:block>
				<fo:block>N</fo:block>
			</fo:block-container>
		</xsl:if>
		
	
		<!-- Nutriscore -->		
		<xsl:choose>
		<xsl:when test="$isNutriScore">
			<fo:block-container position="absolute" top="95px" width="108px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3" />px</xsl:attribute>
			
			<xsl:choose>
					<xsl:when test="$isAktion">
					<fo:block line-height="1em">
	
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					</fo:block>			
					</xsl:when>
					
					<xsl:otherwise>
					<fo:block line-height="1em">
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					</fo:block>	
					</xsl:otherwise>
					</xsl:choose>
			</fo:block-container>			
		</xsl:when>
		</xsl:choose>
		
		
		<!-- Schnelldreherpunkt und R -->
		<fo:block-container position="absolute" top="172px" left="187px" width="12px">
		<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
		<fo:block line-height="0.9em">
			<xsl:if test="@schnelldreher = 'true'">
				<fo:instream-foreign-object>
				<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="10px" width="10px" xml:space="preserve">
					<circle cx="6" cy="6" fill="black" r="6" />
				</svg>
				</fo:instream-foreign-object>	
			</xsl:if>
		</fo:block>
			
		<fo:block line-height="0.9em" font-family="Frutiger 57Cn" font-size="16pt" color="black" >
		<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
				R
		</xsl:if>
		</fo:block>
		</fo:block-container>	

		<xsl:if test="@lagerLieferant != ''">
			<fo:block-container position="absolute" top="155px" text-align="right" >	
			<xsl:attribute name="left"><xsl:value-of select="3" />px</xsl:attribute>
				<fo:block  font-size="17pt">
				     <xsl:value-of select="@lagerLieferant"/>
					 </fo:block>
				</fo:block-container>	
		</xsl:if>
			
		<xsl:choose>
		<xsl:when test="$isAktion and string-length($preiseuro) &gt; 1">
			<xsl:if test="@barcode != ''">
			
				<fo:block-container position="absolute" left="24px" height="30px" top="124px" background-color="white">
				  <xsl:attribute name="width"><xsl:value-of select="69 - $isAktion * $preiseuro2Digits * 9" />px</xsl:attribute>								
				  <fo:block> </fo:block>
			    </fo:block-container>
			
				<fo:block-container position="absolute" top="125px" >
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 1"/>px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>2</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</xsl:if>		
			<xsl:if test="@ean != ''">
				<fo:block-container position="absolute" top="156px">	
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3" />px</xsl:attribute>
					  <fo:block font-size="17pt">
				      <xsl:value-of select="@ean"/>
					  </fo:block>
				</fo:block-container>	
			</xsl:if>			
		</xsl:when>
		<xsl:when test="$isAktion">
			<xsl:if test="@barcode != ''">
			
				<fo:block-container position="absolute" left="24px" height="30px" top="124px" width="80px" background-color="white">
				  <fo:block> </fo:block>
			    </fo:block-container>

				<fo:block-container position="absolute" top="125px" width="80">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 1"/>px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>2</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</xsl:if>		
			<xsl:if test="@ean != ''">
				<fo:block-container position="absolute" top="156px">	
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3" />px</xsl:attribute>
					  <fo:block font-size="17pt">
				      <xsl:value-of select="@ean"/>
					  </fo:block>
				</fo:block-container>	
			</xsl:if>			
		</xsl:when>
		<xsl:when test="string-length($preiseuro) &gt; 1">
			<xsl:if test="@barcode != ''">
				<fo:block-container position="absolute" top="125px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 1"/>px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>2</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</xsl:if>		
			<xsl:if test="@ean != ''">
				<fo:block-container position="absolute" top="156px">	
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3" />px</xsl:attribute>
					  <fo:block font-size="17pt">
				      <xsl:value-of select="@ean"/>
					  </fo:block>
				</fo:block-container>	
			</xsl:if>			
		</xsl:when>		
		<xsl:otherwise>
			<xsl:if test="@barcode != ''">
				<fo:block-container position="absolute" top="125px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			</xsl:if>		
			<xsl:if test="@ean != ''">
				<fo:block-container position="absolute" top="156px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3"/>px</xsl:attribute>
					  <fo:block font-size="17pt">
				      <xsl:value-of select="@ean"/>
					  </fo:block>
				</fo:block-container>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>

		<!-- Inhaltsangabe -->
		<!-- <fo:block-container position="absolute" top="185" left="3">
			<fo:block font-size="12pt" font-weight="700">
				<xsl:value-of select="@inhaltsangabe" />
			</fo:block>
		</fo:block-container> -->

		<!-- Texte -->
		<fo:block-container position="absolute" top="4px" right="0px" font-family="Frutiger 57Cn" font-weight="bold">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>  
			<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute>
			
			<!-- Text 1 / Text 2 -->
			<!-- Der Text darf umbrechen. -->
			<fo:block line-height="0.94em" wrap-option="wrap">
				<xsl:value-of select="$text1and2" />
			</fo:block>
			<xsl:choose>
			<xsl:when test="$isPage2">
				<!-- Text 3, etwas kleiner -->
				<fo:block font-size="19pt"  line-height="1em" wrap-option="no-wrap">	
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext3" /></fo:block>
				<fo:block font-size="19pt" line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />&#160;
					<xsl:value-of select="@lagerLieferant" />
				</fo:block>
				<fo:block font-size="19pt" line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<!-- Inhaltsangabe (Text 4, ist Kurzfassung) -->
				<fo:block line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext3" />
				</fo:block>
				<fo:block line-height="1em" wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext4" />
				</fo:block>
			</xsl:otherwise></xsl:choose>
		</fo:block-container>
	
		<!-- Vorkommastelle mit Trennzeichen und Währung -->
		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="87 - $isFW * 20 "/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="33"/>px</xsl:attribute>
			<fo:block font-family="REWE Preisschrift">
			    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="75"/>pt</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<!-- 
				<fo:inline font-family="Arial Bold" font-weight="normal">
					<xsl:attribute name="font-size"><xsl:value-of select="32"/>pt</xsl:attribute>
					€
				</fo:inline>
				-->
				<fo:inline><xsl:value-of select="$preiseuro"/>.</fo:inline>
			</fo:block>
		</fo:block-container>
		<!-- Nachkommastelle -->
		<fo:block-container position="absolute">
			<xsl:attribute name="top"><xsl:value-of select="87 - $isFW * 20"/>px</xsl:attribute>
			<xsl:attribute name="left"><xsl:value-of select="150"/>px</xsl:attribute>
			<fo:block font-family="REWE Preisschrift" font-size="57pt">
			    <xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="75 "/>pt</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:inline><xsl:value-of select="$preiscent"/></fo:inline>
			</fo:block>
		</fo:block-container>

		<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwpreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwpreiseuro" select="substring-before($fwpreis, '.')" />
			<xsl:variable name="fwpreiscent" select="translate(substring(substring-after($fwpreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<!-- Euro-Betrag mit Punkt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="130"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="18"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>		
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="30"/>pt</xsl:attribute>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="16"/>pt</xsl:attribute><xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/></fo:inline>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46"/>pt</xsl:attribute></fo:inline>
					<fo:inline><xsl:value-of select="$fwpreiseuro" />.</fo:inline>
				</fo:block>
			</fo:block-container>
			<!-- Cent-Betrag, höhergestellt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="130"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="2"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size" ><xsl:value-of select="30"/>pt</xsl:attribute>
					<xsl:value-of select="$fwpreiscent" />
				</fo:block>
			</fo:block-container>
		</xsl:if>


		<!-- Fußzeile -->
		<!-- <xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute> -->
		<fo:block-container position="absolute"  font-family="Frutiger 57Cn"  font-size="23pt" font-weight="bold" top="173px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			
			<fo:block wrap-option="no-wrap">
				<xsl:choose>
				<xsl:when test="$isPage2">
					<!-- NaN -->
					<xsl:value-of select="@nan" />
				</xsl:when>
				<xsl:when test="@grundPreisPOF != ''">
					<!-- Grundpreis -->
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>	
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>		
						</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
				</xsl:choose>
			</fo:block>
		</fo:block-container>
	</xsl:template>







	<!-- Layout für 2.6" Etiketten -->
	<xsl:template name="ETIKETT26">
		<xsl:variable name="isAktion" select="@versTextZahl = 'A'" />
		<xsl:variable name="isBottle" select="@leergutKz = 'P' or @leergutKz = 'B'" />
		<xsl:variable name="isMehrweg" select="@leergutKz = 'B'" />
		<xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'" />
		<xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
		<xsl:variable name="isDreherOrRaemung" select="@schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0 "/>
		
		<xsl:variable name="text1and2">
	    <xsl:value-of select="@artikeltext1" /><xsl:text> </xsl:text><xsl:value-of select="@artikeltext2" />
		</xsl:variable>
			
		<xsl:variable name="text1and2FontSize">
		<xsl:choose>
		    <xsl:when test="$isAktion">	
				  <xsl:choose>
					<xsl:when test="string-length($text1and2) &gt; 36">14</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 32">16</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 28">19</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 24">22</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				  </xsl:choose>
			</xsl:when>
		    <xsl:otherwise>			
				  <xsl:choose>
					<xsl:when test="string-length($text1and2) &gt; 38">14</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 34">16</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 30">19</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 26">22</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				  </xsl:choose>	
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
	
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<fo:block-container position="absolute" left="0px" top="0px" width="360px" height="184px" background-color="{$bckColor}" text-align="center" line-height="28pt" font-size="28pt" font-weight="bold" >
			<fo:block></fo:block>	
	    </fo:block-container>

		<!-- Aktionsbalken -->
		<xsl:if test="$isAktion">
			<fo:block-container position="absolute" left="0px" top="0px" width="25px" height="184px"  text-align="center" line-height="21px" font-size="20pt" font-weight="bold" >
				<xsl:attribute name="background-color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$bckColor" /></xsl:attribute>
				<fo:block margin-top="35px" >A</fo:block>
				<fo:block >K</fo:block>
				<fo:block >T</fo:block>
				<fo:block >I</fo:block>
				<fo:block >O</fo:block>
				<fo:block >N</fo:block>
			</fo:block-container>
		</xsl:if>
		
		<!-- Texte -->
		<fo:block-container position="absolute" top="4" font-size="21pt" font-weight="bold" font-family="Frutiger 57Cn">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<!-- Text 1 / Text 2 -->
			<!-- Der Text darf nicht brechen, da er sonst mit dem Grundpreis ueberlappen wuerde. -->
			<!-- Daher wird die maximale Schriftgroesse berechnet. -->
			<fo:block line-height="1em" wrap-option="no-wrap" >	
				<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute>
				<xsl:value-of select="$text1and2" />
			</fo:block>
			<!-- Text 3 -->
			<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:value-of select="@artikeltext3" />
			</fo:block>
			<!-- Inhaltsangabe -->
			<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:value-of select="@inhaltsangabe" />
			</fo:block>
			<!-- Pfand -->
			<xsl:if test="@leergutPreis!=''" >
				<fo:block line-height="1em" wrap-option="no-wrap" >
					+ Pfand <xsl:value-of select="format-number(@leergutPreis, '##0.00')" />
				</fo:block>
			</xsl:if>
		</fo:block-container>

		<xsl:choose>
		<xsl:when test="$isPage2">
			<fo:block-container position="absolute" font-family="Frutiger 57Cn" font-size="18pt" font-weight="bold" line-height="0.9em" top="70px">			   
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
								
				<fo:block wrap-option="no-wrap">
				  <xsl:value-of select="@nan" />
				</fo:block>
			
				<fo:block wrap-option="no-wrap" >
				    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="@lagerLieferant" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
				
				<fo:block wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@ean" />
				</fo:block>
			</fo:block-container>
		 </xsl:when>
		 <xsl:otherwise>
			
			<!-- Grundpreis -->
			<xsl:if test="@grundPreisPOF != ''">
				<fo:block-container position="absolute" top="81px" font-family="Frutiger 57Cn" font-size="21pt" font-weight="bold" >
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<fo:block line-height="1em">
				
					<xsl:choose>
					<xsl:when test="$isPage2">
					<!-- EAN -->
						<xsl:value-of select="@ean" />
					</xsl:when>
					<xsl:when test="@grundPreisPOF != ''">
						<!-- Grundpreis -->
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					</xsl:choose>
					</fo:block>
				</fo:block-container>
			</xsl:if>
		</xsl:otherwise>
		</xsl:choose>

		<!-- Nutriscore -->		
		<xsl:if test="$isNutriScore">
			<xsl:choose>
				<xsl:when test="$isPage2">
				</xsl:when>
				<xsl:otherwise>
					<fo:block-container position="absolute" top="102px" width="108px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 6" />px</xsl:attribute>			

					<xsl:choose>
					<xsl:when test="$isAktion">
					<fo:block line-height="1em">
					
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					</fo:block>			
					</xsl:when>
					
					<xsl:otherwise>
					<fo:block line-height="1em">
					
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=

		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					</fo:block>	
					</xsl:otherwise>
					</xsl:choose>					
					</fo:block-container>					
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		
		<xsl:choose>
				<!-- <xsl:when test="/LISTE/LABELTYPE = '819' and $isAktion"> -->
				<xsl:when test="$isAktion"> 
					<fo:block-container position="absolute" top="133px" background-color="white" height="52px" >
					<xsl:attribute name="width"><xsl:value-of select="160 - $isMehrweg * 20"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25"/>px</xsl:attribute>
					<fo:block font-size="17pt">
					</fo:block>	
					</fo:block-container>
					
					<!-- Barcode intl2of5 <xsl:value-of select="$fontColor"/> <xsl:attribute name="color"><xsl:value-of select="$barcode"/></xsl:attribute>-->
					<xsl:if test="@barcode != ''">
						<fo:block-container position="absolute" top="135px">
							<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 8"/>px</xsl:attribute>
							<fo:block>	
								<fo:instream-foreign-object>
										<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
											<barcode:intl2of5>
												<barcode:height>12</barcode:height>
												<barcode:module-width>0.013888889in</barcode:module-width>
												<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
												<barcode:human-readable>
													<barcode:placement>none</barcode:placement>
												</barcode:human-readable>
												<barcode:wide-factor>3</barcode:wide-factor>
											</barcode:intl2of5>
										</barcode:barcode>
								</fo:instream-foreign-object>
							</fo:block>		
						</fo:block-container>
					</xsl:if>
					
					<xsl:if test="@ean != ''">
						<fo:block-container position="absolute" top="164px" background-color="white" width="132px">
						<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25+8"/>px</xsl:attribute>
							<fo:block font-size="17pt">
							  <xsl:value-of select="@ean"/>
							</fo:block>
						</fo:block-container>
					</xsl:if>

					<!-- Schnelldreherpunkt und R -->
					<fo:block-container position="absolute" width="12px" height="35px">
						<xsl:attribute name="top"><xsl:value-of select="151"/>px</xsl:attribute>
						<xsl:attribute name="left"><xsl:value-of select="168 - $isMehrweg * 20"/>px</xsl:attribute>
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<fo:block line-height="0.9em">
							<xsl:if test="@schnelldreher = 'true'">
							<fo:instream-foreign-object>
								<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
									<circle cx="6" cy="6" fill="black" r="6" />
								</svg>
							</fo:instream-foreign-object>	
							</xsl:if>
						</fo:block>
						
						<fo:block line-height="0.9em" font-family="Frutiger 57Cn" font-size="20pt" font-weight="bold" color="black">
							<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
								R
							</xsl:if>
						</fo:block>	
					</fo:block-container>
					
					<xsl:if test="string-length(@lagerLieferant) &gt; 0">
					<fo:block-container position="absolute" width="80px" color="black" text-align="right">
					<xsl:attribute name="top"><xsl:value-of select="133"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="101  - $isMehrweg * 20"/>px</xsl:attribute>
					<fo:block font-size="19pt" >
						<xsl:value-of select="@lagerLieferant"/>
					</fo:block>	
					</fo:block-container>
					</xsl:if>
					
				</xsl:when>
				<xsl:otherwise>
				
					<!-- Barcode intl2of5 <xsl:value-of select="$fontColor"/> <xsl:attribute name="color"><xsl:value-of select="$barcode"/></xsl:attribute>-->
				<xsl:if test="@barcode != ''">
					<fo:block-container position="absolute" top="135px">
						<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 8"/>px</xsl:attribute>
						<fo:block>	
							<fo:instream-foreign-object>
									<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
										<barcode:intl2of5>
											<barcode:height>12</barcode:height>
											<barcode:module-width>0.013888889in</barcode:module-width>
											<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
											<barcode:human-readable>
												<barcode:placement>none</barcode:placement>
											</barcode:human-readable>
											<barcode:wide-factor>3</barcode:wide-factor>
										</barcode:intl2of5>
									</barcode:barcode>
							</fo:instream-foreign-object>
						</fo:block>		
					</fo:block-container>
				</xsl:if>
				<xsl:if test="@ean != ''">
					<fo:block-container position="absolute" top="164px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 8"/>px</xsl:attribute>
						<fo:block font-size="17pt" >
						  <xsl:value-of select="@ean"/>
						</fo:block>
					</fo:block-container>
				</xsl:if>

				<!-- Schnelldreherpunkt und R -->
				<fo:block-container position="absolute" width="12px" height="30px">
					<xsl:attribute name="top"><xsl:value-of select="151"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="168 - $isMehrweg * 20"/>px</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<fo:block line-height="0.9em">
						<xsl:if test="@schnelldreher = 'true'">
						<fo:instream-foreign-object>
							<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
								<circle cx="6" cy="6" fill="black" r="6" />
							</svg>
						</fo:instream-foreign-object>	
						</xsl:if>
					</fo:block>
					
					<fo:block line-height="0.9em" font-family="Frutiger 57Cn" font-size="20pt" font-weight="bold" color="black">
						<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
							R
						</xsl:if>
					</fo:block>
				</fo:block-container>
				
				<xsl:if test="string-length(@lagerLieferant) &gt; 0">
					<fo:block-container position="absolute" width="80px" color="black" text-align="right">
					<xsl:attribute name="top"><xsl:value-of select="133"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="101 - $isMehrweg * 20"/>px</xsl:attribute>
					<fo:block font-size="19pt">
						<xsl:value-of select="@lagerLieferant"/>
					</fo:block>
					</fo:block-container>
				</xsl:if>
				
				</xsl:otherwise>
		</xsl:choose>
		
		
		
		
		
		
		<!-- Preis -->
		<xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
		<xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
		<xsl:variable name="preiseuro" select="substring-before($preis, '.')" />
		<xsl:variable name="preiscent" select="translate(substring(substring-after($preis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
		<!-- Euro-Betrag mit Punkt -->
		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="95 - $isBottle * 11 - $isFW * 30"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="42 - $isBottle * 12"/>px</xsl:attribute>
			<xsl:if test="$isAktion and not($isPage2)">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			</xsl:if>
			<fo:block font-family="REWE Preisschrift" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="92 - $isBottle * 32"/>pt</xsl:attribute>
				<!-- with Euro Sign <fo:inline font-weight="normal" font-family="Frutiger 57Cn Bold"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute>€</fo:inline> -->
				<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute></fo:inline>
				<fo:inline><xsl:value-of select="$preiseuro" />.</fo:inline>
			</fo:block>
		</fo:block-container>
		<!-- Cent-Betrag, höhergestellt -->
		<fo:block-container position="absolute" text-align="right" >
			<xsl:attribute name="right"><xsl:value-of select="2 + $isBottle * 2"/>px</xsl:attribute>
			<xsl:attribute name="top"><xsl:value-of select="95 - $isBottle * 11 - $isFW * 30"/>px</xsl:attribute>
			<!--<xsl:attribute name="left"><xsl:value-of select="254 + $isBottle * 4"/>px</xsl:attribute>-->
			<fo:block font-family="REWE Preisschrift" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size" ><xsl:value-of select="92 - $isBottle * 32"/>pt</xsl:attribute>
				<xsl:value-of select="$preiscent" />
			</fo:block>
		</fo:block-container>



		<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwpreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwpreiseuro" select="substring-before($fwpreis, '.')" />
			<xsl:variable name="fwpreiscent" select="translate(substring(substring-after($fwpreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<!-- Euro-Betrag mit Punkt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="142 - $isBottle * 39"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="22"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>		
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="42"/>pt</xsl:attribute>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="22"/>pt</xsl:attribute><xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/></fo:inline>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute></fo:inline>
					<fo:inline><xsl:value-of select="$fwpreiseuro" />.</fo:inline>
				</fo:block>
			</fo:block-container>
			<!-- Cent-Betrag, höhergestellt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="142 - $isBottle * 39"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="2"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size" ><xsl:value-of select="42"/>pt</xsl:attribute>
					<xsl:value-of select="$fwpreiscent" />
				</fo:block>
			</fo:block-container>
		</xsl:if>

		<!-- Pfandangabe Einweg / Mehrweg -->
		<xsl:if test="$isBottle">
			<fo:block-container position="absolute" top="140px" text-align="right" font-family="Frutiger 57Cn" font-size="45pt" font-weight="bold" color="#ffffff">
				<xsl:attribute name="left"><xsl:value-of select="146 + $isAktion * 25"/>px</xsl:attribute>
				<fo:block >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:choose>
					<xsl:when test="@leergutKz = 'B'">
						<xsl:attribute name="letter-spacing">-2pt</xsl:attribute>
						MEHRWEG
					</xsl:when>
					<xsl:when test="@leergutKz = 'P'">
						EINWEG
					</xsl:when>
					</xsl:choose>
				</fo:block>
			</fo:block-container>
		</xsl:if>
	</xsl:template>






     <!-- Layout für 2.9" Etiketten -->
	<xsl:template name="ETIKETT29">
		<xsl:variable name="isAktion" select="@versTextZahl = 'A'" />
		<xsl:variable name="isBottle" select="@leergutKz = 'P' or @leergutKz = 'B'" />
		<xsl:variable name="isMehrwegUndAktion" select="@leergutKz = 'B' and (@versTextZahl = 'A' or @schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0) " />
		<xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'" />
		<xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
		<xsl:variable name="isDreherOrRaemung" select="@schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0 "/>
		<xsl:variable name="containsEAN" select="string-length(@ean) &gt; 0"/>
		
		<xsl:variable name="text1and2">
	    <xsl:value-of select="@artikeltext1" /><xsl:text> </xsl:text><xsl:value-of select="@artikeltext2" />
		</xsl:variable>

		<xsl:variable name="text1and2FontSize">
		<xsl:choose>
		    <xsl:when test="$isAktion">	
				  <xsl:choose>
					<xsl:when test="string-length($text1and2) &gt; 33">18</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 30">19</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 26">20</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 20">23</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				  </xsl:choose>
			</xsl:when>
		    <xsl:otherwise>			
				  <xsl:choose>
					<xsl:when test="string-length($text1and2) &gt; 36">18</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 33">19</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 28">20</xsl:when>
					<xsl:when test="string-length($text1and2) &gt; 22">23</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				  </xsl:choose>	
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>




	
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<fo:block-container position="absolute" left="0px" top="0px" width="384px" height="168px" background-color="{$bckColor}" text-align="center" line-height="21px" font-size="20pt" font-weight="bold" >	
			<fo:block></fo:block>	
	    </fo:block-container>

		<!-- Aktionsbalken -->
		<xsl:if test="$isAktion">
			<fo:block-container position="absolute" left="0px" top="0px" width="25px" height="168px"  text-align="center" line-height="21px" font-size="20pt" font-weight="bold" font-family="Frutiger 57Cn">
				<xsl:attribute name="background-color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$bckColor" /></xsl:attribute>
				<fo:block margin-top="25px" >A</fo:block>
				<fo:block >K</fo:block>
				<fo:block >T</fo:block>
				<fo:block >I</fo:block>
				<fo:block >O</fo:block>
				<fo:block >N</fo:block>
			</fo:block-container>
		</xsl:if>

		<!-- Texte -->
		<fo:block-container position="absolute" top="4" font-family="Frutiger 57Cn" font-size="21pt" font-weight="bold">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<!-- Text 1 / Text 2 -->
			<!-- Der Text darf nicht brechen, da er sonst mit dem Grundpreis ueberlappen wuerde. -->
			<!-- Daher wird die maximale Schriftgroesse berechnet. -->
			<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute>
				<xsl:value-of select="$text1and2" />
			</fo:block>
			<!-- Text 3 -->
			<fo:block line-height="1em" wrap-option="no-wrap" >

				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@artikeltext3" />
			</fo:block>
			<!-- Inhaltsangabe -->
			<fo:block line-height="1em" wrap-option="no-wrap" >

				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@inhaltsangabe" />
			</fo:block>
			<!-- Pfand -->
			<xsl:if test="@leergutPreis!=''" >
				<fo:block line-height="1em" wrap-option="no-wrap" >

				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					+ Pfand <xsl:value-of select="format-number(@leergutPreis, '##0.00')" />
				</fo:block>
			</xsl:if>
		</fo:block-container>
		
		<xsl:choose>
		  <xsl:when test="$isPage2">
			<fo:block-container position="absolute" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold" line-height="0.9em" top="68px">			   
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
								
				<fo:block>
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@nan" />
				</fo:block>
							
				<fo:block>
				    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="@lagerLieferant" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
				
				<!--
				<fo:block>				
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				  <xsl:value-of select="@ean" />
				</fo:block>	
				-->
			</fo:block-container>
		</xsl:when>
		<xsl:otherwise>
			<!-- Grundpreis -->
				<fo:block-container position="absolute" top="66px" font-family="Frutiger 57Cn" font-size="21px" font-weight="bold">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
					<fo:block >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
	
					<xsl:choose>
					<xsl:when test="$isPage2">
					<!-- EAN -->
						<xsl:value-of select="@ean" />
					</xsl:when>
					<xsl:when test="@grundPreisPOF != ''">
						<!-- Grundpreis -->
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					</xsl:choose>
					
					</fo:block>
				</fo:block-container>
		</xsl:otherwise>
		</xsl:choose>
		

		<!-- Nutriscore -->		
		<xsl:if test="$isNutriScore">
			<xsl:choose>
				<xsl:when test="$isPage2">
				</xsl:when>
				<xsl:otherwise>
					<fo:block-container position="absolute" top="92px" width="108px">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 6" />px</xsl:attribute>			
					
					
					
					<xsl:choose>
					<xsl:when test="$isAktion">
					<fo:block line-height="1em">
					
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					
					</fo:block>			
					</xsl:when>
					<xsl:otherwise>
					<fo:block line-height="1em">
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC	
		"/>
					</xsl:if>
					</fo:block>	
					</xsl:otherwise>
					</xsl:choose>					
					</fo:block-container>					
					
			</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
		<!-- Barcode intl2of5 <xsl:value-of select="$fontColor"/> <xsl:attribute name="color"><xsl:value-of select="$barcode"/></xsl:attribute>-->
		<xsl:if test="@barcode != ''">
			<!--	    
			<fo:block-container position="absolute" top="132px" >
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
				<fo:block >
					<fo:instream-foreign-object >
						<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}" background-color="#ffffff">
							<barcode:intl2of5>
								<barcode:height>13</barcode:height>
								<barcode:module-width>0.027in</barcode:module-width>
								<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
								<barcode:human-readable>
									<barcode:placement>none</barcode:placement>
								</barcode:human-readable>
								<barcode:wide-factor>3</barcode:wide-factor>
							</barcode:intl2of5>
						</barcode:barcode>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:block-container>
			-->
			
			<!-- Barcode intl2of5 829-->
			
			<xsl:choose>
				 <!--  <xsl:when test="(/LISTE/LABELTYPE = '829' or /LISTE/LABELTYPE = '82D') and $isAktion">  -->
				<xsl:when test="$isAktion"> 
					<fo:block-container position="absolute" top="120px" background-color="white" width="150px" height="51px" >
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25"/>px</xsl:attribute>
					<fo:block font-size="17pt">
					</fo:block>	
					</fo:block-container>
					
					<xsl:if test="@barcode != ''">
						<fo:block-container position="absolute"  >
						<xsl:attribute name="top"><xsl:value-of select="137 - $containsEAN * 12"/>px</xsl:attribute>
						<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 4"/>px</xsl:attribute>
						<fo:block line-height="0.9em">		
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
						</fo:block>	
						</fo:block-container>
					</xsl:if>
					
					<xsl:if test="@ean != ''">
						<fo:block-container position="absolute" top="152px" background-color="white" width="20" >
							<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 4"/>px</xsl:attribute>
							<fo:block font-size="17pt" line-height="0.9em">
								<xsl:value-of select="@ean"/>
							</fo:block>	
						</fo:block-container>
					</xsl:if>
					
					<!-- Schnelldreherpunkt und R -->
					<fo:block-container position="absolute" top="135px" width="12px">
						<xsl:attribute name="left"><xsl:value-of select="136 + $isAktion * 25 + 2" />px</xsl:attribute>						
						<fo:block>
							<xsl:if test="@schnelldreher = 'true'">
							<fo:instream-foreign-object>
								<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
									<circle cx="6" cy="6" fill="black" r="6" />
								</svg>
							</fo:instream-foreign-object>	
							</xsl:if>
						</fo:block>
						
						<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold">
							<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
								R
							</xsl:if>
						</fo:block>	
					</fo:block-container>
					
					
					<fo:block-container position="absolute" top="122px" width="100px" text-align="right">
						<xsl:attribute name="left"><xsl:value-of select="48 + $isAktion * 25 + 2"/>px</xsl:attribute>
						<fo:block line-height="0.9em" font-size="17pt" >
							<xsl:value-of select="@lagerLieferant"/>
						</fo:block>							
					</fo:block-container>
					
					
				</xsl:when>
				<xsl:otherwise>
					
				<xsl:if test="@barcode != ''">
					<fo:block-container position="absolute" width="137px" height="51px" >	
					<xsl:attribute name="top"><xsl:value-of select="137 - $containsEAN * 12"/>px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 6"/>px</xsl:attribute>
					<fo:block line-height="0.9em">
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>	
					</fo:block-container>
				</xsl:if> 	
				
				<xsl:if test="@ean != ''">
					<fo:block-container position="absolute" top="152">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 4"/>px</xsl:attribute>
					<fo:block font-size="17pt" line-height="0.9em">
						<xsl:value-of select="@ean"/>
					</fo:block>	
					</fo:block-container>
				</xsl:if>

				<!-- Schnelldreherpunkt und R -->
				<fo:block-container position="absolute" top="133px" width="12px">
						<xsl:attribute name="left"><xsl:value-of select="136 + $isAktion * 25 + 2" />px</xsl:attribute>
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<fo:block>
							<xsl:if test="@schnelldreher = 'true'">
							<fo:instream-foreign-object>
								<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
									<circle cx="6" cy="6" fill="black" r="6" />
								</svg>
							</fo:instream-foreign-object>	
							</xsl:if>
						</fo:block>
						
						<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold" color="black">
							<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
								R
							</xsl:if>
						</fo:block>	
				</fo:block-container>

				<fo:block-container position="absolute" top="108px" width="100px" text-align="right">
						<xsl:attribute name="left"><xsl:value-of select="48 + $isAktion * 25 + 2"/>px</xsl:attribute>
						<fo:block line-height="0.9em" font-size="17pt" >
							<xsl:value-of select="@lagerLieferant"/>
						</fo:block>							
				</fo:block-container>
				
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>


		<!-- Preis -->
		<xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
		<xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
		<xsl:variable name="preiseuro" select="substring-before($preis, '.')" />
		<xsl:variable name="preiscent" select="translate(substring(substring-after($preis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
		<!-- Euro-Betrag mit Punkt -->
		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="80 - $isBottle * 10 - $isFW * 27"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="43 - $isBottle * 12"/>px</xsl:attribute>
			<xsl:if test="$isAktion and not($isPage2)">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			</xsl:if>
			<fo:block font-family="REWE Preisschrift" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="92 - $isBottle * 32"/>pt</xsl:attribute>
				<!-- With Euro Sign <fo:inline font-weight="normal" font-family="Arial"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute>€</fo:inline> -->
				<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute></fo:inline>
				<fo:inline><xsl:value-of select="$preiseuro" />.</fo:inline>
			</fo:block>
		</fo:block-container>
		<!-- Cent-Betrag, höhergestellt -->
		<fo:block-container position="absolute" text-align="right">
		    <xsl:attribute name="right"><xsl:value-of select="2 + $isBottle * 2"/>px</xsl:attribute>
			<xsl:attribute name="top"><xsl:value-of select="80 - $isBottle * 10 - $isFW * 27"/>px</xsl:attribute>
			<xsl:if test="$isAktion and not($isPage2)">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			</xsl:if>
			<fo:block font-family="REWE Preisschrift" >

				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size" ><xsl:value-of select="92 - $isBottle * 32"/>pt</xsl:attribute>
				<xsl:value-of select="$preiscent" />
			</fo:block>
		</fo:block-container>
		
		
<!--
		<xsl:if test="$isFW">
			<xsl:variable name="fwPreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" /> 
			<xsl:variable name="fwPreisCharacteristic" select="substring-before($fwPreis, '.')" />
			<xsl:variable name="fwPreisMantissa" select="translate(substring(substring-after($fwPreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			
			<fo:block-container position="absolute" text-align="right" width="200">
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="top"><xsl:value-of select="110 - $isBottle * 10"/>px</xsl:attribute>
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="30"/>pt</xsl:attribute>
					<xsl:attribute name="background-color"><xsl:value-of select="$bckColor" /></xsl:attribute>
					<xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/>		
				</fo:block>
			</fo:block-container>
		</xsl:if>
	 -->

		<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwpreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwpreiseuro" select="substring-before($fwpreis, '.')" />
			<xsl:variable name="fwpreiscent" select="translate(substring(substring-after($fwpreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<!-- Euro-Betrag mit Punkt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="128 - $isBottle * 35"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="22"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>		
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="42"/>pt</xsl:attribute>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="22"/>pt</xsl:attribute><xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/></fo:inline>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46 - $isBottle * 12"/>pt</xsl:attribute></fo:inline>
					<fo:inline><xsl:value-of select="$fwpreiseuro" />.</fo:inline>
				</fo:block>
			</fo:block-container>
			<!-- Cent-Betrag, höhergestellt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="128 - $isBottle * 35"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="2"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size" ><xsl:value-of select="42"/>pt</xsl:attribute>
					<xsl:value-of select="$fwpreiscent" />
				</fo:block>
			</fo:block-container>
		</xsl:if>
	

		<!-- Pfandangabe Einweg / Mehrweg -->
		<xsl:if test="$isBottle">
			<fo:block-container position="absolute" top="122px" text-align="right" font-family="Frutiger 57Cn" font-size="48pt" font-weight="bold" color="#ffffff">
				<xsl:attribute name="left"><xsl:value-of select="146 + $isAktion * 25"/>px</xsl:attribute>
				<fo:block >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:choose><xsl:when test="@leergutKz = 'B'">
						<xsl:attribute name="letter-spacing">-2pt</xsl:attribute>
						MEHRWEG
					</xsl:when><xsl:when test="@leergutKz = 'P'">
						EINWEG
					</xsl:when></xsl:choose>
				</fo:block>
			</fo:block-container>
		</xsl:if>
	</xsl:template>




      
	
      
	<!-- Layout für 4.3" Etiketten select="contains(@text1, 'Asia')" -->
	<xsl:template name="ETIKETT43">
	    
		<xsl:variable name="isAktion" select="@versTextZahl = 'A'" />
		<xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'" />

		<xsl:variable name="WineRecommendation" select="/LISTE/ICONS_WINE" />
		<xsl:variable name="isNoWine" select="/LISTE/ICONS_WINE = 'NO_WINE' " />
		<xsl:variable name="isWine" select="string-length(/LISTE/ICONS_WINE) &gt; 7 " />
		<xsl:variable name="isNoBakery" select="/LISTE/BAKERY = 'NO_BAKERY' " />
		<xsl:variable name="isBakery" select="/LISTE/BAKERY = 'BAKERY' " />
		
		<!-- Preis -->
		<xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
		<xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
		<xsl:variable name="preiseuro" select="substring-before($preis, '.')" />
		<xsl:variable name="preiscent" select="translate(substring(substring-after($preis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
		<xsl:variable name="preiseuro2Digits" select="string-length($preiseuro) &gt; 1" />
		
		<xsl:variable name="zutaten">
	    <xsl:value-of select="@text_20_4" /> <xsl:value-of select="/LISTE/ZUTATEN" />
		</xsl:variable>

		<xsl:variable name="isBakerySmall" select="string-length($zutaten) &gt; 330"/>
		<xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
		<xsl:variable name="hasNoBarcode" select="string-length(@barcode) &lt; 1"/>
		<xsl:variable name="isDreherOrRaemung" select="@schnelldreher = 'true' or /LISTE/JSON_TAGs/@Raeumung &gt; 0 "/>
		
		<xsl:variable name="text1and2">
	    <xsl:value-of select="@artikeltext1" /><xsl:text> </xsl:text><xsl:value-of select="@artikeltext2" />
		</xsl:variable>
		
		<xsl:variable name="winetext">
	    <xsl:value-of select="@text_11_1"/><xsl:text> </xsl:text><xsl:value-of select="@text_11_2" /><xsl:text> </xsl:text><xsl:value-of select="@text_11_3" />
		</xsl:variable>

		<xsl:variable name="winetextFontSize">
		  <xsl:choose>
			<xsl:when test="string-length($winetext) &gt; 100">13</xsl:when>
			<xsl:when test="string-length($winetext) &gt; 80">14</xsl:when>
			<xsl:when test="string-length($winetext) &gt; 60">15</xsl:when>
		    <xsl:otherwise>16</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<xsl:variable name="text1and2FontSize">
		  <xsl:choose>
			<xsl:when test="string-length($text1and2) &gt; 40">20</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 35">21</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 30">23</xsl:when>
		    <xsl:otherwise>25</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
			
		<xsl:variable name="artikeltext1FontSizeWine">
		<xsl:choose>
		    <xsl:when test="$isAktion">	
				  <xsl:choose>
					<xsl:when test="string-length(@artikeltext1) &gt; 34">16</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 26">19</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 22">21</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 21">22</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 16">24</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				  </xsl:choose>
			</xsl:when>
		    <xsl:otherwise>	
				  <xsl:choose>
				    <xsl:when test="string-length(@artikeltext1) &gt; 36">16</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 28">19</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 25">21</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 23">22</xsl:when>
					<xsl:when test="string-length(@artikeltext1) &gt; 18">24</xsl:when>
					<xsl:otherwise>25</xsl:otherwise>
				  </xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>

		
		<xsl:variable name="text_20_1_FontSizeBakery">
		  <xsl:choose>
		    <xsl:when test="string-length(@text_20_1) &gt; 26">12</xsl:when>
		    <xsl:when test="string-length(@text_20_1) &gt; 24">14</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 22">16</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 20">18</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 18">20</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 16">22</xsl:when>
		    <xsl:otherwise>25</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="text_20_1_FontSizeBakerySmall">
		  <xsl:choose>
		    <xsl:when test="string-length(@text_20_1) &gt; 18">14</xsl:when>
		    <xsl:when test="string-length(@text_20_1) &gt; 15">16</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 12">18</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 8">21</xsl:when>
			<xsl:when test="string-length(@text_20_1) &gt; 7">23</xsl:when>
		    <xsl:otherwise>25</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<xsl:variable name="zutatenFontSize">
		  <xsl:choose>
		    <xsl:when test="string-length($zutaten) &gt; 600">11</xsl:when>
			<xsl:when test="string-length($zutaten) &gt; 350">13</xsl:when>
			<xsl:when test="string-length($zutaten) &gt; 300">14</xsl:when>
			<xsl:when test="string-length($zutaten) &gt; 150">15</xsl:when>
		    <xsl:otherwise>15</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="zutatenFontWeight">
		  <xsl:choose>
		    <xsl:when test="string-length($zutaten) &gt; 600">normal</xsl:when>
			<xsl:when test="string-length($zutaten) &gt; 350">bold</xsl:when>
			<xsl:when test="string-length($zutaten) &gt; 300">bold</xsl:when>
			<xsl:when test="string-length($zutaten) &gt; 150">bold</xsl:when>
		    <xsl:otherwise>bold</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<xsl:variable name="icon_asiatisch" select="contains($WineRecommendation, 'asiatisch')"/>
		<xsl:variable name="icon_dessert" select="contains($WineRecommendation, 'Dessert') "/>
		<xsl:variable name="icon_fisch" select="contains($WineRecommendation, 'Fisch')"/>
		<xsl:variable name="icon_gefluegel" select="contains($WineRecommendation, 'Geflügel')"/>
		<xsl:variable name="icon_gemuese" select="contains($WineRecommendation, 'Gemüse')"/>
		<xsl:variable name="icon_grillen" select="contains($WineRecommendation, 'Grillen')"/>
		<xsl:variable name="icon_kaese" select="contains($WineRecommendation, 'Käse')"/>
		<xsl:variable name="icon_kalb" select="contains($WineRecommendation, 'Kalb')"/>
		<xsl:variable name="icon_lamm" select="contains($WineRecommendation, 'Lamm')"/>
		<xsl:variable name="icon_mediterran" select="contains($WineRecommendation, 'Mediterran')"/>
		<xsl:variable name="icon_pasta" select="contains($WineRecommendation, 'Pasta')"/>
		<xsl:variable name="icon_pizza" select="contains($WineRecommendation, 'Pizza')"/>
		<xsl:variable name="icon_rind" select="contains($WineRecommendation, 'Rind')"/>
		<xsl:variable name="icon_schwein" select="contains($WineRecommendation, 'Schwein')"/>
		<xsl:variable name="icon_vorspeisen" select="contains($WineRecommendation, 'Vorspeisen')"/>
		<xsl:variable name="icon_wild" select="contains($WineRecommendation, 'Wild')"/>
		<xsl:variable name="icon_suppe" select="contains($WineRecommendation, 'Suppe')"/>
		<xsl:variable name="isBottle" select="@leergutKz = 'P' or @leergutKz = 'B'" />
			    
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A' ">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

		<fo:block-container position="absolute" left="0px" top="0px" right="2px" width="522px" height="152px" background-color="{$bckColor}" text-align="center" line-height="21px" font-size="20pt" >	
			<fo:block></fo:block>	
	    </fo:block-container>

		<!-- Aktionsbalken -->
		<xsl:if test="$isAktion">
			<fo:block-container position="absolute" left="0px" top="0px" width="25px" height="168px"  text-align="center" line-height="21px" font-size="20pt" font-weight="bold" >
				<xsl:attribute name="background-color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$bckColor" /></xsl:attribute>
				<fo:block margin-top="16px">A</fo:block>
				<fo:block >K</fo:block>
				<fo:block >T</fo:block>
				<fo:block >I</fo:block>
				<fo:block >O</fo:block>
				<fo:block >N</fo:block>
			</fo:block-container>
		</xsl:if>

		<!-- Wein -->
		<xsl:if test="@text_11_5 != ''">
		
		<!-- Wein -->
		<xsl:choose>
			<xsl:when test="$isAktion">
				<fo:block-container position="absolute" text-align="right" left="305px" width="215px" top="3px">
				<fo:block>
				<!-- Asia -->
				<xsl:if test="$icon_asiatisch">
				  <fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAFfklEQVRo3s2ay0tUURzHv+fO+CoTHxP5iBSZIIooKhGkB7SwhQTtCiHITRG1EWrRomWL/oSIFkFUu4hcFrVQijAQiTSdTDPHzHQ0dWacce63xb3ePN7H3Lnz0C9cBu49c87vc37nd+65v3MEASJbFRUBra1AWxtw9CgQDAJ79wKBgPZMVYHFRWBqCgiFgIEBoK8P6O0F4nHkRATo6fL5yHPnyCdPyEiEnvT3L/n8OdnRQfr99GwLwMxBSkvJa9fIr1+ZU4VC5I0bZFlZnkGEIC9eJL9/Z141Pk52dmrt5Rykro7s6WFB9eYNGQzmEOTMGXJ6mluipSWyq8uVd5xBOjvJeJxbKlUlHz4kS0o8gnR1kWtr3DZ6946sqsoQpLNze0Gsa2iIbGhwCdLaSkaj3LYaGCDLy9OAVFbmf3rNhR4/Nk0AMsijR4U1aG2NTKW8TQAdHTYgp055qzQX8tLu0BBZXLwJRAiyr6+gtmvLPO3izIw1XDrAK1c2gbS1ae7aCggrra4a5RzV32/EigIAuHoVEAKFkNjQjmarhYqLpXK2OnYMaGkBACgoLQUuXMiv9brBEsTIiLnczIxUjiSQSjn1CnD5sl7h2bO5WUaoqjYLxWLk8jL569f/Z26G09ycVG7jfx01OUkqCv04eTLzHk4kgOJiUy/LTtDDUAjn4aSqgKIA1dWyJ9Z7PJ0aGoDDh6HgyJH0hZeXpTEuSkq0XycIVZUgSBoGSv/Vf00Q7oMOOH0aCvbvdxzXACB27XI03ASxtgYoimzc+LhUx8ZeN91TVbnS2VnnRltaIDg7SwQC8oNYDCgrczdzbIbYNDvRKtBJY3iaIFZXAd3jdnWb9OkTBJNJwu93nCYzgbCKB7f3MDsL7N6dtm3qw9bQwgIErVBTKcDncw3jxmCSmqHxOMS+fY5eTNve/DxQVSXd81uW9PmAVAok0/fO5KQ7iFjM1NteIACYIDSQaBTYscMaZnracKNVQ4xEgMpKk3EmY1MpU8x5hWA0ar4Zj0PBnz/2M1t9vTEWSYK6l0iCi4vuIPROke6PjWkzmwsIjo7KgR4Omwv9+AEF09Np10ZGY4ry/0FFhWyc3oABatPjDIeBpibA77f28vr/h4e1G8GgXK6pyQZkbMyaQO8xSyAr42prtbXSyorh7s1xwrk5rZz+rqCqgokEGAqZ2hEHDlh7zOcz2xoKwY91clP0+G2D3QRRVycHdiQCVFXJ91ZWgGjUWIq4mUhc6/Nn+DEw4GExqw+b37+BQEA2OByGaGgwv+l37oQoL/f8ngIA2r3h+/shWFtLTE3J49/NN4T+dhalpc7TrsXC0duXAO3XgTU1UDAzA3z7Zl/DxIRlrAhFkSBsG84BhKN6e4FEAgpI4PVr+4KNjZmtSJNJLXgt3vZZecPOhpcvN2z0tLe7ynJs/Dgq5MUvX6ztisfJQGBD8qGoSPvSclIksjUQTnr61CKvdfdu+s/Knz+3D0QqRZ44YQFSXU3Oz6eH0cvkHWBiwtmOFy+ktKmcMr15033CYWQkL0AkyUTCue2VFbK52SH36/ORvb1ZJ908AwwOumusu9vFtkJjo5GaKQRQxurpIRXF5UbP+fNkMpnT1KglwMJCZhUODmpbHxltvXV3Z58PVlVtPC8tGflczxoett2tSr8ZeudOQZPbtp3x4QO5Z08Wu7pCkLdv52SYedazZ2RFRY4ODLS3k+FwYQGmpshLl1yfgHB/hKOmhnzwIP/eWV4m791z5YXsDtUcOqSdCMo2eC3Wcrx/n6ytLdDpoPWrvp68dYt8/967l1SV/PiRvH49Yw9svkRODp4FAtqhs+PHgYMHgeZmoK4OqK4GSkrkxHg4rB08e/sWePUKGB21/9bIQP8AZl2tPWcsd0YAAAAASUVORK5CYII="/>
				<xsl:text> </xsl:text>
				</xsl:if> 
				<!-- Dessert -->
				<xsl:if test="$icon_dessert">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEHUlEQVRo3tVaz0tUURT+3psmp8jQmQnLWYSIbkQUjJGsXLgwSFq0MoZAWkmICxEXLly68E8QQRQqXArNTsQW0w/IaIjIn5lIvElKEh111Ga+Fq+J0WbGd++7b7IP7urde+797jn33HfOuRoBwi7cbiAYBG7cAOrrgaoqIBAA/H7zGwlsbgKGASwtAdEoEIkAL14AiQSUgOY04s3lIm/fJh8/Jn/8oBS2t8mJCbKtjTxzhtJrAShOxOMhOzvJhQUqxfIy2dVlynecSHs7+fkzHcXqKhkKkZrmAJErV8hwmAXF9DRZWamQSHMzGYvxn2Bri3z4UAGRUIhMJPjPMTJCFhVJEunoIH/+lJs4w4uZjhH2yTx/TpaWChIJhchkUnrO9OJzNZLkxoa44I8fzfNqiUhjI7m35xiJI2RkNB6NkhcunECkpMSWe7VKwra5jY+fQGR01JYZO04gjVSKvHMnB5Fbt8wOdoTPz+clRZLc31fjyebmSLf7GBFNI1++lBO4v28e3MPDvBqy9O3gQGzujo5jRK5fl9ZG1l03jJzuV6nJzc7++ZUxiYyNOeNiM/o6doaCQRKgDo8HuHdP6Ndf0zShPvz2DY7hwYPfk7S0OOpmpV3z16/WFvPlC6lp1HHzpnJt/IW9PfExZWXW+gUCQG0tdNTVwXFsbjorv7kZOqqrxUJjSoT4ly6Jj1lYsN43GITG798Jn88x88okLjvuRLx9Cx0lJWI7dXgoNsnq6pHFWRkrrPXKSmiUspWMQ3zuXPZv29tAcTEKBV2o9/H7IBcJoKAkAEDjzg5x/ryz7lcm3yZiKIkEdGxsWB+QTOJUYm0NOgzD+gCXC3aOlBCWlgSJrKyITbC+XhizqqoSIq1jbk7416FgWrGKDx+gIxoVH7izczoOeRqzs9B4+TJhGICEN1LtwZiO90TkxuOAzwcd6+vA8nLhdi+frN1d8Q2NRICDA+gggampwppCLhkC99kfTE5mFHpaW+3XNiSCJ1uJOtLMS/v9GTG7221GWnaxtiaWZPj0yd58T55kyWsNDKjNoCeTZCx2dPEqM/upFHntWhYiXq98LdBCfK8ck5N5Uqbd3f8HkXicrKjIQ8TlIiMRpeblCJGeHgtlhatX5WoXOTKVOYnI5pnD4ayF0uyFnrt3hV2ijOsV1tT792bpQ6j01tNzuojMz5OBgGQxtL/f+sUUi5G7u1mz8rbx+jVZVmazPN3XJ3/zqsDTp2RxsaIHA62tR0oFBYFhkPfvW34BYf0Jh9dLDg87r514nBwcJC9edPhRTU2N+SJIVQktszY/NHTiWVBHJN3Ky8neXvLVK3ktpVLkmzfko0fCGjjeNCUPz/x+oKkJaGgAamqAigqgvBzweoGzZzMDDyAWA969A2ZmgGfPgMVFJYHZL/Q8jPWbpIcQAAAAAElFTkSuQmCC	"/> 
				<xsl:text> </xsl:text>
				</xsl:if> 
				<!-- Fisch -->
				<xsl:if test="$icon_fisch">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEDUlEQVRo3tWaTWgTQRiG391mtdS21hjQNpdWa0GKKAgRtfTgoQVLzy25FE8i4qEiPfTuwYsHbypIQfw5FtSTiB5aFSwYitZWCymhTVGwvzGmUfN62GbJz26yP7PJ5oUhbWZndp75ZibzzTcSAcKpFAUIhYDz54FTp4Bjx4BgEAgE1DwS2NgAVlaAxUUgEgGmpoDpaSCVghBRfY31VFdH9vWRDx+S6+u0pe1t8ulTcmCA9Plouy0ArYPU15OXL5MLCxSqxUXy6lW1ftdBhobIaJSuammJDIdJSXIBpLWVfP6cFdWrV+TRowJBenvJ1VVWRVtb5KVLAkDCYTKVYtV1/z65d69NkJER8u9fekZv3pAHDlgECYfJf//oOc3NqfPVFMiZM+Tv3/SsIhGysbEMSEuL+8urCE1MlAF58IA1oUyGvHjRAKSnR31AtH78cAfmyxdSUQpAJIl8+1bcS2IxkqS6lSudHGlkpADk7Fkx1kgkTAMIAZuZ0bYyKsjEhHOIz58dAdgGCoV2QerryY0NZxDz80IhLAHdubMLcuFCUZ6lHtnedg3CFMzyMilJlNHTo+twSZKk/lHKg9vagtTUBLeltUVPwSBw4gR8OHkyP+PPn7wKVAMZvGD/flRKJdvS2wsZXV1F/nduAa03fv4030uCVNhww3eGQvChtdWwkmzB7Ge24kpCcHMzz/K6ljl+HDJaWvRrWlvTNW8lIPJUMBIAAN++5f/f2QmJpSZBhXrfyXDLSi5ZKp2uCQgVJJk0Linq8MxtpVKQdcdgVs3NtQESi0FGPF4z88OwPbEYZESjxRnRqG6hMutC5WA2N4tWMR/m5oqf7ugwXtfTaUBRqmYt3c789AkyIpGyJswrrCjqd1+/emfVmpmBxMOHiXgcyGl84S+5oZJJoKGhKtsVTYkEcPAgZHz/rsYsrEIAQEMDkMm4PneYSBhnTk0B6TRkkMDLl3mFmLMDLitZdm0hIKnWu2+f8UOTkzmBnr4+MYcOyaRjn11zpMycOadSZCCQ47MriuppiVI8bgnIth4/1k5RZM2ZuntX3JjYdQ24s6MNj1LJ5rgDbt/WiSH6/fZjgdXQ5GSJI9Nr12oD4tcv8siREiB1deT0tPdBRkdNhBXa28m1Ne9CvHihGyjVD/QMDnorWpXV7Kwa+rAUert+3VsQ8/NkMGgzGDo+7g2I9+/JQ4cchqfHxqo7zJ48IZubBV0Y6O/Xfq0rpnicHB42fQPC/BUOv5+8d8996yQS5M2bpqzg7FJNdzf56BG5syMWYH2dvHWr7FwQB5JNbW3kjRvku3f2rZTJkB8+kFeuWLZAYZKEXDwLBIBz54DTp4HubtXnb2sD/H5gz578jd7qKvDxI/D6NfDsGSDIZf4PypNg2QWCCPAAAAAASUVORK5CYII="/>
				<xsl:text> </xsl:text>
				</xsl:if>
				<!--Wild -->
				<xsl:if test="$icon_wild">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAADFUlEQVRo3tWavUvrUBjGn6Qt7SBStWDVQdBNER1UUEsHhwoFJwe1CsWpoDgURHBxFFwcdRAEoUg3FS24iIMfk4OCOPgPiP4FfgzPHWquvaVpzklOepMHztA0nLy/PO9J0/c9GgHCqUIhYHQUmJgAhoaA+Xnzc4+PgcdH4OYGuL0FPj6gRARoawQCZCpFFgp0pGKRTKfJYJC2YwEoDxKJkLkcVQnA74eVlfL8roPMzlK1ykmBfw9mMqSmuQASj5Pn58oBarpSqd5ehSDJJN2SAWAKQpJLSwpAMhn5PJcI0kiruiAkub9PhsM2QbJZx3fUMkCzNWKmlhZJEAknKgOpDkgGpHrNmAJ2dAiCjI46WrRCi7hGwGajppqaLECiUen1UOuzVSAiAHVBDg8tQA4OpFPKbKGrGqZKp01AEglbP2QygSiDMBQK/QXRAQCaBlxfy72jkSjHVvt49feapknPb6mFhd/5CRBjY8DdHdyUAULSEkoIwpCuAyTKjuRycFtmDjqCAICRkTIPIhEgm0WjJJtillpc/EmtyUni8tIzENKO/KRXEImE/1yo1sAAghgc9F5gskomoVHCy0YA2EqtQkEcxLMQxjLxZSrZAWkUhBM3hB3xOoQQiIqLeCK1/OCGMIgfXNFRLML32tuDjudn/4M8PUHHwwP+V3opm/P+HhrjceL11bVXlHp/pJSBhMMI4u3N9t2sFWDDHwwXF8DXF3SQwO6u/ATv7954up2eVjR6Uin5yuLnp3DVw1aFRFSxWEU5KBSy1cuwC6EM5Oioqhz0/Q1sbnqi+CClnZ2KCxgFutZW246odlFIJyd1Sqarq/4B6empAxII+AMknxdoK3R3S1Xi7YLYVqlE6rpgo2d62rsg0ahk6y2fV/r4VQLS1WWzGbqxYelAw0Da2x22p9fXbXV1lTQ/jS0ezc2KNgxMTSkLTuqpNTcnvANCfAtHWxsbpq0tIRecbarp73cPYHvbci2oAzFGZye5tqYGYHlZ2oHqoSnZeBaLAePjwPAw0NcHzMzUP79UAq6ugLMz4OVFyfvjH+rthWGQgGR9AAAAAElFTkSuQmCC"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!--Gemüse/Veg. -->
				<xsl:if test="$icon_gemuese">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEu0lEQVRo3sVaS2gTXRT+ZpK28YmGaG0CiooviigoLb66cJGNuFayUVciuinowoVLF27diSAKgq5EUVciuogPsGBQsFHjI5IHBmMaY5o0aeb7F9PE/Ml0cudmJvkgZJi5nHu+e849995zrkKA6BYDA8DYGHDgALB7N7BlCxAIAD6f/o0EZmaAZBKIxYBIBAiHgRcvgHIZtoB6N9Z/LhcZDJK3b5O5HKVQKJB375JHjpBuN6V1AWidiMdDnj5NfvxIWxGLkWfP6vIdJ3LsGPntGx3F9+9kKEQqigNERkbIR4/YUzx9Sm7ebCORiQkynWZf8OcPeeqUDURCIbJcZt9x/To5NCRJ5MQJcn6+90pXKmSx2P7++XNy9WqLREIhslbry+DrKwKMP374QPr9gkTGx8lSqa8kTMlEIuTy5R2IrFrleHhtU7Ra1f+jUTEiJHnrVgciN270Z9Q1zZjkYtA0fTdgSOTQoYZAx5DNthGpK932bmbGXFY0Sg4MtBBRFPLly77NBUNyiYTe+MuXxQWdPNlCZN8+OWvUavqeSzTC1WpCJEyJNWNqqrGV0YncvCmmSDxuPcpIWsSQzOxsu7CxsQUiHo+5Py5EFeHO6pYyQz4vR8QIV68uEDl8ePEOSyX50Zubs91ChutbIkEqClUcPGh84iqXoSxZIn1gU4aGzBtkMuKHv0wGJAGPp/1jIADs3Ak3du0yVqQLEg0ZiqIr0AxNg+JyLa50rQaUSsCyZeIdTUzAja1bDa1hF9rIqKp5e5ernXwnjI9DxcjI/1/OzdlijVYyRs+m7XM58Q527IDC+XmixdQinVlOclSrgNttSbawZfJ5KGxp7QSJhlId5oc0EQAqeonfvx0hAQAKi0Vi6VLnXYsUlmt5spfLUJHNdkWCP3927NiyYlbx4wdUpFLdCVm7thFhSBorXSo55lL/iHz9Ku0qDXep1fSXhQJQrf5rMz2tK2ZzOG9DLAYV09NyEajZHdes0R9WrNAT1XVs325NbjwuR+T9e7gRiVielPXvJEFNg7KwWjev4lIusn69HJGpKYDDw4aHKqvb69ZnJpOWZBrmskQz+oODVJHJ6DWLVjOn0x3nR33UDbcghYK1UW1ZAoQRDgOVClSQwJMn7Q3WrQPzeV3h2Vnw82dQ0/TdaTOpxTaY27aJz41iUX6iP3jQVOgJBrvLJhicxa0coKRRLpM+HwlQn6XPngGJhPyoqCpYqbQHhE+fnA279+4Bv361lN4uXeo+zxOPm460rdbQNHLvXoMEndcrXws0UFjUtaRx/75JyvTcud6mS2Uz/sUiuWmTCRGXiwyHnWEhGBCEMDkpUFbYsIHMZu0n0pJaYiwmJ+fxY1JVBQs9R4/aX61KJru3xrt3eunDUultcrK31ahOiEbJQECyGHrxojNErCbMX78mh4e7LE9fuGCbm0lZ484dcuVKmy4MBINkKtXbgmIqRR4/LnwDQvwKh9dLXrvWnXVE1o2/f8nLl4Ws0N2lmtFR/UaQhWy7EHI58sqVjnPBPiL1n99Pnj9PvnolbyVNI9+8Ic+csWyB1p9iy8Uznw/Yvx/YswcYHQU2bgT8fsDrBQYHm09kQDoNvH2r77gfPrRth/wf9yp2e3vLXbQAAAAASUVORK5CYII="/>
				<xsl:text> </xsl:text>
				</xsl:if>
				<!--Kalb/Beef -->
				<xsl:if test="$icon_kalb">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEAUlEQVRo3s2az0sUYRjHvzO7tm6u4M+KrYuCEYqaKF6SiA3yXl0LksRLBHrqEIhRp0BE8D/IrulF1KJfB4MENQIvLZqlwuaqla5rrjPfDuPWro6778zOzswHXliYd9/3/b7vM+/7zPs8EgEiV06dAkIh4NIl4OJF4Px5oLISkKT0erEYEA4Dnz4BU1PA5CSwuAhLIEBTpaiI7Ogg37whEwmaQlXJmRmyu5ssL6fpsQA0LqS8nHz0iIxGaSmxGDk4SJ47l2chBQVkTw+5ucm8srNDPnlCBgJ5EHLhAjk9TVtZXCSvXbNQyM2b5O/fdARVJQcGSJ8vRyE9PaSi0HGmpshg0KSQBw+0GXELS0tkXZ1BIXfuuEtEkkiErK8XFNLWRv75Q9eysqK7RePIGfH9O13Pu3ekx5NByPCw84P89Uus3r17xwgJhex/L3Z2/v/e3ydJal6TVnS34yTr62RZ2SEhkkR+/Gj/7CcSaQPPVo4cBX19h4SEQo5ak5AIPX78IAsLSYAyAKCrS9xdjscBVQXW1rLX3d3NXmdpKbN3ToLxuP7Dykrg+vWDikVF5Pa20B5uxAxEZ9fUSqQyNnZgWu3tli1/vkpGdnfJkhLKaGvLvPR7e5AOvvS4vAwnkCRJe6X18PmAK1fgRUND5lZOnPhnq46iqoDHo//s8mV4UVOTfTYcwNDEtbZC4uYmUVKSVUiyYTuEGV79aBQSFYWQZXcJ2dsDCgoMmZ03k4g0FOV4G3VyNQBAliFD9I/b2+4UkdSCWMy2zkRs3eyO5sXGBhAIZK8sUseh1cDWFmSsrIh1YsH7QfJfOYKI73Ycy8uQsbCQ80ylDjBTSXM89RxAs4TDkDE/n7tdiHi5qfj91trl58/wYnbWEdsmeeSMMs30NCRWVBCRCITPk0OHYi6DsESIogBnzkBGNApLzMspZmaAaBTaMkxM2L9lWsXIyMGBCAAvXrjfwz3OtX/+PEXIhw/Aly+OTaokSZqtG2V8HPj6NUWIqgJDQ86aiJkD9+lTnRjiyZPk6qqh73crr4IM8/Kldh+ne2V6965jQgy1l0iQjY0Z7n5lmXz1ylYhae2JRgEePxYIKwSDWhxChIUF+y6tk7x/rwVmhQI9V6+aj53nk3CYPH3aYOits9Md8cPUKG9Vlclg6P377hAzO5s1kSB7ePr2bTIed07Es2dkcbFFCQPNzeT8vL0Cvn0jb9zIQwqH36/loMRi+RXw8yf58KGWtJPXpJqzZ8n+fq1Dq0PPvb1kaalN2UHJEgiQt26Ro6PmUzz298nXr7V2/P6c0pwkSxLPfD6gqQloaQFqa4HqaiAYBMrKtO9zj0dzTBUFiESAuTng7VtgbAxYXbXE5/wLXVJ448jjduAAAAAASUVORK5CYII="/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Rind/Beef -->
				<xsl:if test="$icon_rind">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAED0lEQVRo3tWaz0sUYRjHvzOrKShiq+DmHqRELxIFgZKJhw4FSmdjL+VJRDwIEfQHeOjSwVsKIUTUIUKpThF1sBQ0WgrUYkER3VVQXMsfu+uu3w7vuu3uzOzOzs44s194Gd53333n/czzvO+88z6vRIAoVuXlQHs7cOMGcPUq0NICeL1Afb34jQTCYWBjAwgEAL8fmJkBvnwBIhGYIorbFJ5cLvLWLfL5c3J3l4b09y/56hXZ20uWldFwXwAWDlJZSQ4MkL9+0VQFAuTQkGjfcpC+PnJlhZZqdZX0+UhJsgDE4yHfveOZ6uNHsrnZRJDubjIUoi3684fs7zcBxOcjIxHarokJsqLCIMi9e2Q8Tsfo82fy/PkCQXw+MpGg47S4SF64oBOko4M8OnIWwOamuB4ekn4/WV2dB6S21vrptVDFYhTvbfwvm5zMA/LsmbMgkp6RAonFRPnJCdnTowHS1SUq2K2trYzOpyDW1jLrLS2R5eVZIJJEfv169p1OJMhgMKMoG0DhVum6fz8L5Pp1TWtoNWwkFdumQgsLqaWMAJmcVFaKREyFMO1hHB9n9rO9PQlSWUmGw5Zbw2yrpjQ2lgS5ebNkIFRh1tdJSaKMri6UmiRJ+p/xeoHLlyHjyhWVz0aWBkwiITLd3ZDR2qqsFQqVhmlcLnHt6IDE7W2irk7bdA4V073m2zdIjMeZInMoCPO5+t4eJKrUOgUhaTsUdY5XWVESjRbUwBmQ6AQ5PMwsqagQ181NZ7iUHo+IRCBjZ0d9fHg89lsjq2+aWluDjGBQ+STW151hjazZNDfIykrKF1PW8Hrtn7329/XXDQRQhsXFU58SPHt7In9w4PiZKqWfP1EGv19kNjbARAKQkxNZVVVpQADAwgIkejxEMKg6O2S7ltZN9Lig2n/1tp/XBevqIGNrS8QsinhSXF0FyZzJEksAIs4Si0EGCXz4UNwKuKnJvklhejrtzZ7MZNndOW93LUWjwOvXaSCfPomwWKnpzRtgezsN5PgYePrU3k7pGKcK13/yRCWG6HarxgJz7isVo3A48ztcYwNEU1NTObZMh4cVG2h5N8mMKh433vbBAXnpUg4Ql4ucmdG2ism79IZBRkZ0hBWamsidnTNxL0Mg79+rBkrVAz137mREqywbJ8m2devHDxH6KCj0NjLirBDD8jLp9RoMhj565AyIuTmyoaHI8PTDh/YGRV++JGtqTDowcPu2Io5huYJB8u5d3Scg9B/hcLvJ8XHrrbO/T46O6rJCcYdq2trIFy/IaNRcgN1d8vHjvGPBPJDT1NhIPnhAzs4at9LJCTk/Tw4OFmyB7CSZcvCsvh7o7ASuXQPa2oCLF4HGRsDtBs6dy1zohULA9+9ixf32LfD7tylrzn+MLQwIOerjTgAAAABJRU5ErkJggg=="/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Suppe/Soup -->
				<xsl:if test="$icon_suppe">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAD/0lEQVRo3t2azWsTXRSHn5kkTYlSNAaMyUJUFKSIolixfu3qorjoSgmIuiqimyIu/ANcuHFfBEEQdamoKxFdxA9QMYhoNSWKSEoXtbYmGts0v3eRvn3TGpP5bNP3Bxdmkpk59+GcO/fOOdcQCLcKhaCrC/btgx07YPNmSCYhFqv+J8H375DPQzYLmQyk0/DkCZRKeCJVzdhvgYB0+LB0/bo0Pi5H+vFDunVL6u2VgkE57gvIPkh7u9TfL334IE81PCydOVN9vu8gR49Knz7JV33+LKVSkmH4ABKPS/fuaVH18KG0aZOHIAcPSiMj9uJ+YqJ6PDkpwDnM5KR06pQHIKmUVCrZsl19f/DHsSSpXHYGduWKFA47BDlxQiqXbdusCzIzUx/Mjh4/llavtgmSSs0Z9wTk92/3IJL07p2USFgE2bNH+vXLsa26IKOj888deHpOmYy0cmUTkFWr3L1eZ8fAQpA/wNyASNK1a01Arl51Z6BSsQYyNeXajnp7/wJy4ED1ApeyBDI25n6eGRqSQqEFIIYhPX3qyTxmCcQrnTy5AGTvXk+8Ua+z9c4906tXc0sZE4D+fjAMPJeEr9q5E3bvBsCkvR36+vwxZBioUEDlsn8wx4/PgnR3Q0eHt474+PG/kxUrIBCocZLHXurrA8MgyP799m6sVODnT5iehpmZ6m+BAITDEIl439FmSiZh2zaCbN9uI1IMm0NkkaAOHcJky5bGF3375mKIGLabI3V1EWTdusadWbNmUSOlFkbZLJgmRCIQj//9pq1bMVQuq3Ywug0nv9QwTCcmMGQ1kMtlCAaXDKxZN03LTwoGl6TzyuUszUOGikURifj25vLLA/NUKmEyNsay15cvmOTz/xOQXG75g2SzmLx/v/xB3r7FJJNZ/iAvX4LicesfVbncvK8+P5utzGZbm0xGR2F4uGXnkqZKp2FqChMJHjywdlM43Hogd+7UFHp6eqy5sVhsrdAqlaRYrCb5EApJX7/aSsC1BMiNG3NZlOpaa3oaBgebu7HBKnkJFmJw+XKdGmI0aqkW2DIeuX27Qcr07NnlAVIsShs3NgAJBKR0uiVgGmpgwEJZYf36prnZJQW5f79uobR+oefIkcap/0LBf4h69t+8qZY+bJXeBgYc531deeBv0TA0JCWTDouhFy6oJfT8ubR2rcvy9Pnz7itMbnTzptTR4dGGgZ4eKZ9fXIB8Xjp2zPIOCOtbOKJRaXDQf+8UCtLFi5a84G5TTWdndUfQbMnZM42PS5cuNR0L3oH82xIJ6dw56dkz516qVKQXL6TTp217YGEzPNl4FotBdzfs2gWdnbBhAyQSEI1CW9v8hd7ICLx+DY8ewd27UFtLcaF/AIrTsZsVX9lkAAAAAElFTkSuQmCC"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Käse/Cheese -->
				<xsl:if test="$icon_kaese">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAADsUlEQVRo3tWazUsbQRjGn0k26qGUNgYak0Op0oKIKAiR+gke7EF6ruSiPZWiF5Ee/AM8ePHiSQRRKK1Hi3oSaQ9RC21pkKJWxYrISg/Wr6ipX08PW62VNJndnU3SBwYCmdl5f+87Ozsz7wgChF15PEAoBFRXA+XlwP37QDAI+HzGfySwswPoOrC8DESjQCQCTE8D8TiUiEY35ovbTT56RL58SW5v05L298mREbKpidQ0WrYFoHmQvDzy2TPy61cq1coK2dZmPN9xkCdPyG/f6KjW1shwmBTCARC/nxwfZ1o1NUUWFSkEqasjNzfNjfvdXeP33p49mL098ulTBSDhMBmPq/Py6am1dgMDZG6uRZCWFusdO6F378jbt02ChMPk2RmzTvPzZCAgCVJZSR4dST3X+Az9KWlRNEreuJEC5NYt6en1OkRaoYaHU4AMDiqBcBzo/NxYDSQEqa01KiiEcBRocZH0eK6BCEHOzCiPhuNAra3XQB4+dDQajkF9+nS5lDFAhobSEg1HoEKh3yB5eX+WFBmCsAXV1/cbpKFBuk06YaSBNjZIIaihpkZ+E0Zrm0khhOV2KfsMBoHSUmgoK7NkjBkoqw6QVn09NDx4kLzSjx+A16vMy8nALDsrFIKGgoLklRJA2JWsE6SGFgAUF0Pw9JRwux0b57YPR2RAdnchKBm/rAYBoKnuyAzwRVsVTnLh8FCpt2Q9eLWe7VktHocLW1vItGxHZH0dLuh6Rr4FF8YreffW1+HC6mrGvKtsAllehoaFBdtGq3xpLUX/yxdoiEYzP8bt6uNHCPr9hK4DEsaky2BTEYnFgPx8uPD9O7CygmySKYdFIsDxMVwggclJpd5UMcMJIeSA3ry5kuhpbFS2qVK9EUuqeJz0+a7s2T0eY6el8CwrLbvEV68uT1FcAICTE6C/P3u+1HJjGOjtTZBD9HpT5gKz5nCOJEdHkxyZtrfzv9DBAVlYmATE7SYjkewH6eiQSCvcvUtubWUvxMREwkRp4kTP48fJs1WxmPMGJ+p/bs5IfZhKvXV0ZMbj/xoNi4tkMGgxGdrVlR3D6f178s4dm+npFy8ymxR9/Zq8eVPRhYHGRlLX0wug62Rzs/QNCPkrHF4v2d/vfHRiMbK7WyoK9i7VlJQYN4J+/lQLsL1N9vSkfBfUgVyUQIDs7CRnZ61H6fyc/PCBfP7cdASuF6Hk4pnPB1RVARUVQEkJcO8eEAgY58Y5OX8v9DY3gc+fgbdvgbExYGlJyRryF1XR46xZcnNxAAAAAElFTkSuQmCC"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Pizza -->
				<xsl:if test="$icon_pizza">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAC4jAAAuIwF4pT92AAAGWUlEQVRo3s1aS2gTXRT+7jR9aNqaPqGtFXyAWsUuSjcV1IVFxLULXwtBXLhR0b0LFwouXKkrBRc+FqIbcaEggtIuxFIqxSa0tZq02ljTd9M0mfn+xc1MHjOTzKSJ/Q8MTHLvzD3fnHO+e+85VxAgChUhgLIyYP9+4OhRoKcH6OwEWluB8nLZriiyr6YBqgr8/QsMDgJ9fcC7d8DAABCPAyxcDQAA5SucXUKk7tvbyRs3yG/fSFWlIZqWeaWL/ltvU1VybIy8dYvcsUO+X7/c6AXQHRBFIffsIR89IpeWzIoWKqpKrq6ST5+S+/bJcYoORP9CdXXk3btywFJKNErev082N7uykDMgR46Qo6PFs0Au0V1ucpI8eVJaZ91AysrIK1fIWOzfgLByuYcPydravGDsgXg80pUSicJAFAu4ppEDAykycAVEUch79+QXcaGQJMHUxZ8/iwcmGCS7umyJAKZ4UBTy9m1r+swxUDYIA0yxgGgaOT9PHjpkSQBmIGfPunYnOxBFA5IeM+EwuXt3DiCKQu7dS87OOn+pqmYqPTJC+v0Z4Eoi/f1kZaUNkLIy8sMH55bIBhEIpO6npkoLRNPI69czrJICcu6cMxCqSq6sOHKnkgEhpec0NWUBqaoiAwHHlGqnvHE/PV1ai+hy86ZhFVAI8tix/NbIAcJQeHxczsiljhFdAgGyoiIJRFHIFy+sgej/JRJ52emfsJaVfsePk0JQgc8H9PbKvYNpjU9gehrC44HIamc4DA4Pg8EgNkyEAE6fTip04oT9BOTACv90HrGSmRnS66WCnh7z7kwIQAizFWZm8L+T+nqguxsKOjttrCac7zLXu03Vt8KaVph7HTwIBTt3puLBRiGSUtmGBlvABYOZnZXvUBRgejqnHrbS3Q3BSITw+WRiwOORDaurQFUVhBCGgm4s5Mha8ThQXm52XxJIJFK65B8A8PuhoK4O0DSI5EuFEEBVFbC4mAIwOZnzixsWsxso/dLFAoQxnscDhELOrdPWlqSVsTEz26yskMvLedkpQ+bnTf0KWTFnPJtvJZ5kWAUkUF1t/jKbNwMLC+Dqqq1rpbudEAKorc0RkyLVDwAjkQwrWllU6HkzIfISgWA0SlRWWtKtMYCmAYpi7c9ZIEmafluRghF/kYiMz6YmS+Iw/gsGga1brVFEowBDoVTmIpf7xGLkwoK5LRKxXPXa/ZfPtaxWzhltVkm/79+pYHIyxcfRqL2JKyqAmhpQVcFIJNVWX+9q/hE2ljckGDTahRAy6LPnjWwSCIWgYHw81SHJVnZgDL6vqwOXlvJOovT73c8JmzZl/rZyp+RHN2R0FApGRjI71NQAqmpLp0bQVlcbtMtoVFpK0+RFgpoG7NplTdVjY/ZAGhvBHz9k36mpzLiJxVLje73A3Jx85utXeDA4aH6ZogBJJXO5QT43oqaZVtVOXM+4b23NJJzKyszOPp+0+JcvANvbZSDbcXQkUvheRA/MtD18QfsZGyIy5q4tW5I7xOFhx1nDgoCkMZtrEMvL9my6tib7CEFZhXn7Nv8KM7ncYCzmaIGo+7m+HDG1h8OmSTEjjiYmgJERCK/Xen779UsuZS5eTDIZQB4+XPIktSsrxOP55xpNIxcWZPkBSFqkrw/w+zdsb2SwXzwOjI8DFltr00oDAF6+BMLhrNLb5csl35VaftmlpQyycbxtTiTIAwcsEnS1tWQoVNpaRzyeygdEo+5dLr02+eyZTaZRCPLMmcLrIfkkT3YyJ4C5OXPCYds2m9yvEDL/++qVu5KCU1lbW38+TF/cXrjgoKzQ3ExOTGSWnIvkWo4B/Plj/TFVlXzyRFbTcgLRr54eOREV2zJDQ/bK//6dv9Dz8SPp9boovQlBnjolS9HFBKK7hm5tu4MFVs/198vsu00dMXdV9/z5javoprvT69ekz7eO8rSikNeubRwYTSOfPyfr69dRnk53s97e0hBArngIheR0YBHYhZ9FEYJsbCQfPEitOEsli4vykE1Dg6sDNnB1oEZRyI4O8vFjmfcq5qGAmRnyzh2ypaVEh2qsjjkJQba1kVevkp8+mUHlYqJ0porHyc+fyUuX5KGd9Pe7BCIKPniW3A5DCKCpCejuBrq6gI4OYPt2oKVFJr3TkwmqCkxNAUNDwPv3wJs3QCBQWOI6S/4DlY6IviB7Ou4AAAAASUVORK5CYII="/>
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Vorspeise / Starter -->
				<xsl:if test="$icon_vorspeisen">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEt0lEQVRo3s1aS2gTURQ9b5q0QYrWELQmiH9BilDwU7TShYtsxLWSjboqopuCLrpw6cKtOxEEUdSlouJCRBctChYMClpLILGfBAOl0aZx2iY5LiYNk+nL/DLT9MCDZOb9zrv3vvvevSMIEK0iGAROngQGB4H+fuDQISAWAyIR7R0JFArA3ByQSgHJJDA2BoyPA6oKT0BtGOelo4OMx8lHj8iFBbrC4iL57Bl57hwZCND1XAA6JxIKkcPD5M+f9BSpFHntmta/70QuXCDTafqKTIZMJEghfCDS20u+esUNxbt35IEDHhIZGiJzObYFf/+SV654QCSRIFWVbcf9+2RXl0sily6R5TI3DT58ILdvd0gkkSArFW46/PhBRqM2iQwMkP/+cdMimSS7uy2I9PQ42l41f6qVBqyu+kvm4UMLIg8eyBvq1axYJNPpBhKyQpIslfwhUq1qpwEpkTNntAo2Vt9u8RWTk2QwaCAiBDk+Lm+wtOSKhO9ESPLyZQORU6fk0qg927REJibqRxkFADA8DAjReCwulQAhIIzPAfDXL2wKHDsGnDhRm1QoRBYKjuxC/9603vy840V2LMm7d2uqdfasY9swenzXarW8bG87N8PsLCkEFQwOysW2ZQu0viXIZus/ZaonxZ8/jf/zeYiuLoia+hr70T83HSMWA44ehYL+fnmFarV54927Lee9bhLbtjVW2LHDO1sZGoKCw4flLxXFcrXtSKOpVB22qy9KpbK+8sAAAti1y/19n7SvWl7EF5otypEjUNDT47hDIQQwM2M5kKk0jDaja+NYigcPQtCi1dqK66sJIer/je/1ErIzIaNEjePYXRjFkRTWOqxUgGLRdGCzQc12IzNVFUJoBxIpkVLJkUoJIQBFAbq73Sl6uWxKkiSQychPFM3aqSoUzM+7shGnKlRHIGBdZ+/e5n3LJDY9DUXv3FwZvQc7UMNka/5rzehlNionkk43rzA3Z49MPt8yyfpuVS477yOVgoLv303dP3//tladmpd26/zqKBQaji228e0bFCSTtiZpe0cz2T4t4cKnAQAmJgD29ppecUnWg3S2LlOZjBYh1NUnSa6sWJ50XV3QFhfJzk6CQpBTU9bH5SYhItOBp6cd3TtcXQfevKndEEng7Vtr8YVCpkZKElxZAVUVWF62PCXL7KmhL1JzvFZ29+KFLtETj0ujFG7v6ht2h1dVMhLRBR+CQXJmxpMQkJ9lHZ48kcS1bt3yLJ61IUSqVfL4cQmRcFieC2whruWrNJ4/NwmZXr8u18V8vr0kjO5haYncv9+ESEcHOTYmJ7O62h4SBv9DkhwZsZFW2LPHPB6Vy7VPnUjy9WtSUWwmes6ft5Wt8o3A7Kx8wK9ftdSHo9TbyIirPIlvfmZykozFXCZDR0dd+SnHk7eS/qdP5M6dLaanb95sb1L06VNy61aPPhiIx8lsdmMJZLPkxYu2v4Cw/wlHOEzeu+e/dIpF8vZtW1Jo7aOavj7y8eN1kfSWsbBA3rljaQveEVkr0Sh54wb58aN7KVWr5OfP5NWrjiVgLMKTD88iEeD0aS2D1NcH7NsHRKNAOAx0duovHEAuB3z5Arx/D7x8CUxNeRIX/g+cBvcTC+0M3QAAAABJRU5ErkJggg=="/> <xsl:text> </xsl:text>
				</xsl:if>
				<!-- Mediteran -->
				<xsl:if test="$icon_mediterran">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Grillen /Barbeque -->
				<xsl:if test="$icon_grillen">	
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAC4jAAAuIwF4pT92AAAGGUlEQVRo3sVazWsTTRj/zaZ9q20tsV9SpYJa0FaxB+nBClbQHvwDRPw6CHrxoqJ3Dx4UPHhST4oe/Lj1Ih4URLDYg1iKgtWSatW0Gm1sm/QjbbL7ew+Tze4mu0lmN33fBwaSmd2Z5/d8zezzjCBA+CUhgFAI2LULOHQI6O0FuruBjRuB6mo5rmnyWcMAdB2Ix4GREeDNG+DFC2B4GEinAfpnAwBAOUV5TQjrd3s7eeUKOTpK6jpzZBjOZifzvzmm6+T4OHntGrl1q5zfbCp8AVQDomnkjh3kvXvk/Hwho35J18lUinz0iNy5U65TcSCmhNavJ2/elAuuJi0tkbdvk62tShoqD8iBA2QkUjkNFCPT5CYnySNHpHYCAwmFyAsXyOXl4iDMsdlZdbDFntd18u5dsqGhJBhvIFVV0pQymbJAACh0aJKMxchEouC13PP2QOE1//CwFQyUgGgaeeuWXKQUiGSSMvi5ABkZsfrNvulp9+dLgfnxg9yzxzMQoMAfNI28ft09fHqQgykbEAfDbs+rmJ9hkHNz5P79rgGgEMjJk6XNybaAF7NcWbHG0mkHCGUgdp/5/Zvcvr0IEE0jOzvJmRklSTkY03XL5vN9JztWAMRPJBwaImtqPICEQuSrV2oT25gtcF7DIBMJV38IpBVznsuXHVqxgJw6FSh0ejIXj1tjNo0VgFdde2aGbGnJA7JmDTk25l86+ZK2h9tUyurPO4M5fMiPiV29mtOKBiGAvj6go8P/CTifUinLemtq5OHUPN26Pa/r7v2l6OhRecoGIIGcPYtKEUmgqSnHoDAZTKctZslcP0ngn3/8LdbRARw8CAgBDeEw0N/vTyImLS5aDNulHgqBHz+CsVhOcgCAZLK0Vsu1huPHsxrZuxdoaFCbYGnJua8KAZJSutn/uYU6O4GWFvlhZY5nP7ZIyv6slmAYQCymxsvhw0BtLarQ2+tc3NtmACEcks/ZfW1toXTzNWT/v24daDMv1+WSSaCurjRfjY1ATw+q0N3t/ZBhWJ+qLhOKIOZYiurrXQXpal779kHDtm3ek8XjEFktiDxtrDYprdnTA8G/f4lw2FOF/yXzRSOhl0ZI4PNnCLJI+kLXgVDofwdTjEWQwPw8tKIzaBpAgoZhtaBpm3IYHx+31tP10qmi+noIGgZV4/hqa4i6bgWZ0urK7iPLy2rJMXO/WE0zUhGUEEAqBQ3xePCzVeVDlpJgEYtBw+SkqshWTStU3dVNikah4csXdWkJAVTY8Tk6CjQ3+3s5EkEVPn3y97LtvBTU+fnzJ7Bhg3+z/fABVRgZCeqd4PQ00NSkDCinUVUHz6d37yDY3k5EIv6/CXyGZs7MAOFw8AWTSaC9HRqiUSASqYyh2/zGPNbntxyFwxWoiRAYHAQSiezO/vx5ZYBomvOLsNQelMkEBzMwIM2SANnXFyzTbhjk0lLZaR7llKkXJRKy/JDLolRXy8pTECA2BlUaFxf9r3v/vkte6/x5tUkyGW8pp9Pkyoos2iwsyOrW7KzVxsaCZxwzGXL3bhcgDQ1kNFreJN+/e2rAV4Zybk49w/n4sUemUQjyxInSCew/f4Kbi2GQU1P+fWV6mty82SP3K4TM/w4MlCwpOBhYWCCTSbWcrlu28evX0mDMstyZM2WUFVpbyYkJz0qSQ/IumXclE/v1S00ruk4+fCiraUWBmK23V0raRTMOZu3VKbfktJ9sfjENvn5N1tUplN6EII8dk6VoFynlFv72LZhGDIOcny8PyNCQzL571BGLV3VPny6s6E5MuDLs6IvHlcOpJxBdJ58+JcPhAOVpTSMvXXKCyTMh1/BbqlLrRhMThZcRDIN88oRsbAxQnrabWX+/MwBkN8OKgXDzh2hUbgcuju3/LooQZHMzeeeOpR1dlzv47Kzc0MyqU9DbEcmkvGTT1KR0wQZKF2o0jezqIh88kJtepa50ZOvvvHGDbGtbpUs1btechCA3bSIvXiQHBwtBFdOMvfyWTpNv35LnzslLO/b5FYEI3xfPsllICCHrHz09wJ49QFcXsGUL0NYmK1dr1zpTsFNTwPv3wMuXwLNnwNiYxU4A+heco2jFmTM2WgAAAABJRU5ErkJggg=="/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Lamm / Lamb -->
				<xsl:if test="$icon_lamm">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEA0lEQVRo3t1az0tUURg9942TEinmDGT+wpTaSLiQjMpatDAQAlcig1CtBMWNSIv+gKBN+woCg8JlIa1CcqHhwmhAMIuHijhvUKf8OTrqOKfFa4ZpnPdz3jjPDlyGYb659573fffd+33nCgJErvB6gdZW4NYtoLkZuHwZqKkB/H71NxLY2ABCIUCWgWAQmJgAJieBWAyOgOow1pvHQ7a3k2/ekOvrtIXtbXJkhOzoIIuKaHsuAK0TKSkhe3vJuTk6Clkm+/vV/vNOpKuLnJ9nXrG4SAYCpBB5IFJZSY6O8kQxNkY2NjpI5PZtMhxmQbC1RT565ACRQICMxVhwvHpFFhfbJPLgARmP0zUYHyfPn7dIJBAgj47oOszOkhcvmiTS2kru7dG1CAbJc+cMiJSXkwsLdD2Ghw2IvH7NU4FEQj0NZCXS1qYanBbMzZFebwYRIcgvX9wxwViMXF0197J5+DCDyI0bhffG3/1KPceqzRDT06mjjAQA6O0FhEBBUVwMkTEHYTSnlhbg2jUAgISSEqCz0/rAs7OpwZItBUVRP6emjtmk7CIRU5M2JNPT8zcfuXvXViSkh4DdZqUvTSwvk0JQQlubNU/s7Bg/JZM45kk7qK4Grl6FhOZmc3+Ix9XBS0vhOty5AwlXrhgbyjKE1+uYJ+x6D9QoL1y/DsFIhPD5tHs4PIQ4c8YVD55aRL5+hWA8Tng8xk/DJWAicXyr2NyEoCZNlxLRmK6E/wQSdndPP4tYDBJ+/dI3OjoqXBj9+AGSqXBismKZiaUlFEFRgNpa7d48HpA88XWSuRZS38vLsxKRMD9/+kNLliHh+3d9o6UlV721smJmBhKCQX2jurrCTC4aNW87PQ3BykpCUXTzkUKvD6NDLHw+SFhZUTULLYRC7iUBqDrLwQEkkMCnT7rHZMud54LNTWv2Hz6kCT3t7caZ1MaGYwmV5eRJL8/3+9OKD16vmmkZYWUlfwSiUetE3r1LVVGk5FEdL14YuzHLKZkkGA6DkUjWEEzfmXVx9qzVxQQ8f55FQ6yoMK0F2gqFtbV/dY+tLfshRZLv3+uUTAcG8kfEyX6iUbKhQYeIx0NOTrqfyOCgCVmhvp78/du9RD5+JCXJpNBz/762WiXLjhFJkjGNmRlV+rAkvQ0Omivv54JQyFr1vbraphj65Ik7KvRTU+SFCznK048fF1YUHRkhy8ocujBw7x6pKCdLQFHI7m7TNyDMX+Hw+ciXL/PvnZ0d8ulTU17I7VJNUxP59i25v+8sgfV18tkzw7XgHJFkq6oih4bUhWjXS4mEqjr19Vn2QGYTjlw88/uBmzdVBampCbh0CaiqAioqgPS6MQmEw8C3b8Dnz8DoKPDzpyNpzB8xs/0aT7O4jAAAAABJRU5ErkJggg=="/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Pasta -->
				<xsl:if test="$icon_pasta">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEI0lEQVRo3tWaz2sTQRTHv7NpNEKoGgtNk4PYogdLsSCtWLXXguChXpQgFE9FxINSCv0DeujFexXEQ1s9eFDUk4geWhUsGBTqDwKVotsWsbU2tmmzydfDtjGNMTO7maTrF4aQ5O3sfOa9mdmdN4IAUa78fqC9HThxAmhtBQ4eBKJRoK7O/o8EfvwAvn4FEgkgHgfGx4GJCSCVghbRvo3z4vORXV3kyAi5uEhXWl4m794lT58ma2roui0AnYMEAmRvL/nxI7UqkSAvX7brrzjIuXPk9DQrqs+fyViMFKICIOEw+egRq6qnT8mmJo0gnZ3k7Cy3RT9/khcvagCJxchUituumzfJnTtdgvT0kJalpyGWRWaz5dXx/Dm5d69DkFiMzGT0QCwv057lQabT5dU1NUU2NCiCHDtGrq5qjYwciA7F42QwKAHZs6ci0+smCAB7Edz4zbVu35aA3LqlfU3IhygsTCZtu/l5u6gqm7WfBoqCnDpV/oCUeOMvkDwbx3r/nvT7C0CEIF+8qMjMWQqkGJQj9fQUgBw/XnVvlARZWlK7weRk7lHGAAD09gJCYDslhMgVWJbaRUePAm1tAAADgQDQ3Q2viCQQCqlfcOHCBkhHB1BbC8/p2zcgm5XbnT0LCIEanDzpqfaLvBC3h5lE0SjQ0gIDR47AiyKp5hEA6OyEgUOHPAmC6WnAMNRs29thoKFBbqjaMzpDrLHxD5BMhw9D0LIIn6+4gWkCkciWuFUKiX/EvOsQk2lpCcY/IQDAshw3JLcW6IJIp+WGu3dDUIacTALBYNmNqpg3NmRgZaW0RTDoiam4pFIpGPj+XV+FmnrX8b1nZmDANKsXKisrjoGU7GdmYEinN9J1b27R3Bywa1euccxk7M9SZXVVre5EAgampmS+1eOOcLhgdCosdoGAWt3v3sFAPI7/XpOTEAyHCdOU9nxVFjY3SiaBfftgYH7ezlnIGjI3B3765D1vjI8D6+swQAJPnsgvqK8Hmpq8B/LgwcaCmPdFqkzGWxBra8C9e3kZK7+f/PJFbT9Jx+aCLo2N5XZRbI+k08DwsMoy66U3L+D69SI5xFDIcS7QkUd0bzfdv19iy/TKlYruKGrTr19kY2MJEJ+PnJhwXvHCQtFt0Nxv6+t6Qa5eVUgr7N9PLiy4S5MV2bzWrsePiyZKiyd6zpzRm63Spbdv7dSHo9TbtWv0lD58IKNRl8nQgQFvQLx6RdbXl5me7u/XGx5OdecOWVur6cBAVxdpmtUFME3y/HnlExDqRzhCIfLGjcp7J5kkBweVvFDeoZrmZnJ0lFxb0wuwuEgODUnHgj6QzRKJkH195MuX7r2UzZKvX5OXLjn2QGERWg6e1dUBHR12Bqm5GThwAIhE7ITNjh1bH/RmZ4E3b4Bnz4CHDwFNL2u/AQFfsqlJRtKHAAAAAElFTkSuQmCC"/>
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Chicken -->
				<xsl:if test="$icon_gefluegel">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAEHklEQVRo3tWazUtUURjGn3OnycHKSgf8mEWUGIREgR9RiYsWBkHQKmIQ0pVQtDCiReCyRf9CQSCRulTSXVELjSChIUKGkhStGQe/KmdyihmfFlcnM+fec889d0YfOLiY4z3nd973fL3vEQQIt/L7geZm4Px54PRpoK4OCIWAYND8jQS+fQO+fgUmJ4FIBBgdBcbGgHQaWkSzGefF5yPb2sgnT8jlZSppZYUcGCAvXSL37KFyXwA6BwkEyK4uMhqlVk1Okjdvmt/3HOTqVfLzZ3qq6WkyHCaF8ACkqoocHmZB9eIFWVurEaS1lYzHWRT9+EF2dmoACYfJdJpF16NHZEmJIsj162Qmwx2jV6/Iw4cdgoTDZDbred/M1f9vsdXEBFldLQnS3EyurhYUQBqEJCMRcv9+G5BDh8ipKe8Istm8EI5genttQB4/9nyPsAORgllbM08D24K0tJgVvNTysh4Q0jxZ+P1bQIQgX78uzOqzPliWILGY3Lc6OraAnD3rvTUkJnvOGrJ71/h47ihjAAC6ugAhsBMkhABKSswjv50aGoCmJgCAgUAAuHLF/p9WV82/09PqvYxGzY7KwIRCct9sb1+/j1y4YG/C9X1FeiK6cSun+vKFFIIGWlrsqQOB3EgKIYBsVt1t8l3wqHhRDYWAkydh4NQp64rfv//fAZ/PWWOplJRLKau1FQaOH7eudPBgviGUb2jfPvs6s7PqIGfOwEB1tZqLyI7w/LycNSor1UFOnIBgJsO8rpJMQhw4YB28sLGMrEspz5EN96fNF0SB9hdmMs7n3iYZ2CmKx91tpEyliNLS4lvEjWul0zCwuJi/QiKBXaGZGRiIxSxXElcjpWmzlAOZmrKu9PPnzrfIp08wMDFhXam0tGBWUdaHDzAQiWDXa3wcglVVRCxmu1MXYvVSsnwyCVRUwEAiYeYsvFwevdToKPD7NwyQwPPnRe+P8kANDW1K9LS1abkYuSlKSqfJYHBT8MHvN29adpqd9Q5CJfjR17dNXKunp2hWYSKhFlZqbNwGpLzcUS5QmyWSSTW3Ghy0CJneuqU1mKB1PmxWKkUeO2YB4vORY2OOo4aOoyRug4Hd3RJphSNHyKUl9UZmZv4DyqWidWhkhDQMyUTP5cvuslW/fmmLg/2j9+/N1Iej1Nvt21qCcdoUjZKhkGIy9N49V1bJuZbb3PybN2Rlpcv09N27am6WSOhZrfr7ybIyTQ8GLl6Uz1ksLLjPE5Jme9euSb+AkH/CUVFBPnxob525ubwgUktvMknevy9lBXePaurryadPcyuTzrQcHzywnQv6QDZKTQ155445EVWX6rU18u1b8sYNxxbYWoSWh2fBIHDunJlBqq8Hjh4FamqA8nJg795/A9/xOPDuHfDyJfDsGfDxo5b7zB+0IIyNiafffAAAAABJRU5ErkJggg=="/>
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Schwein / Pig -->
				<xsl:if test="$icon_schwein">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAACXBIWXMAAFxGAABcRgEUlENBAAAD4UlEQVRo3tWazUsbQRjGn9kYjVI/GgN+5CBVFIoUBEvEDzxaKAjFS0soSE8i4kGRQg8ePfgvtCA5aPWoqDelPUQsVGiooG0J+EEb6UGtGk3UNE8Pq6majdndbOLmB0N2Mzsz+8y7O/vOvCMIEKlitQIuF9DaCjQ0ALW1gNMJOBxyHgn8+QP8+gX4/YDPB3i9wNISEA7DECg3oz1ZLGRHBzk+Tu7vUxdHR+TUFPn0KZmTQ933AlC7EJuN7Okhv3+nofj9ZF+fXH/ahTx/Tm5sMK1sbpJuNylEGoSUl5Nzc8woi4tkTY2BQtrbyZ0d3gmHh+SrVwYIcbvJcJh3zrt3ZF6eTiHd3WQkQtPw8SN5/75GIW43+fcvTcfaGllRoVKIy0WGQjQtPh95714SISUl6R9ejcDjSSJkbIxZQTQqewOKQtrazPleJGJ9nbRabwgRglxaYtbR3X1DSHOzbC69RCKya5FpVlZirowsxOPRXsnpaexQdqKTp7TgcpEAJdhswLNnmt1/kZcHIQSEEOrLXFwfK8PUp0J4+RIAIKGlBSgu1nwzqSKEAIRIPLEKhdRV1NUFCAEJra3xmcGg/Lu1ZbiAuE7Jz5dPotHreQUF6tpzOoFHjyChoeHGlJEQhYXycVXV/95LI0IICItFucMODpJX0N4OCXV11/+MROIfgQyh2Jaax76pCTmoqIhfSMiwgJR5+BCCkQhxYVZVPZRhqGZkOziA4C1XmsUqasRI2fDkqOlQCScnyHox4TAk7O5mzTud8Fu2vQ0JgQCynu1tSNjYyH4hfj8krK0pZ15xT8yE4gi2uooc+HzKJS7cE1MJSDQMr6xAsLycCARkTzQbP4rBIFBaCgm/f8sxC5NCEjg/T3yB1wucnUECCSwspOYipElArO0L/0+RmZkrgZ6OjqQzSrXTWb1JF+Ew6XBcmbNbreTPn4kL7O2ZS8Al798rrGsND2u2ihHWurqIoXmR7vFjBSF2e9JYoO7ejEbJoyNjLTI9fcuSaX+/JqvoIU6InkDq8TFZXX2LEIuF9HozK0QPAwMqwgpVVeTurnIFoZAhN5JS+fl5UpJUBno6OxNHq+4y7PD1qxz60BR6Gxw014L1t2+k06kzGPrmjTlEfPpElpWlGJ5+/fpug6KTk2RRkUEbBp48IQOBzAoIBMgXL1TvgFC/hcNuJ9++Tb91gkFyZESVFVLbVFNfT05M6HctErG/T46OJn0XjBNymSoryaEhcnlZv5WiUfLzZ7K3V7MFbiZhyMYzhwNoaQEaG4H6euDBA6CyErDbgdzcayv92NkBvnwBPnwAZmeBHz8Mmb/8A1AxYxozJpOPAAAAAElFTkSuQmCC
				"/><xsl:text> </xsl:text>
				</xsl:if>
				</fo:block>
				</fo:block-container>
			</xsl:when>
		    <xsl:otherwise>
				<fo:block-container position="absolute" text-align="right" left="305px" width="215px" top="3px">
				<fo:block>
				<!-- Asia -->
				<xsl:if test="$icon_asiatisch">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/>
				<xsl:text> </xsl:text>
				</xsl:if> 
				<!-- Dessert -->
				<xsl:if test="$icon_dessert">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if> 
				<!-- Fisch -->
				<xsl:if test="$icon_fisch">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!--Wild -->
				<xsl:if test="$icon_wild">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!--Gemüse/Veg. -->
				<xsl:if test="$icon_gemuese">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAMAAAAp4XiDAAADAFBMVEUAAAABAQECAgIDAwMEBAQFBQUGBgYHBwcICAgJCQkKCgoLCwsMDAwNDQ0ODg4PDw8QEBARERESEhITExMUFBQVFRUWFhYXFxcYGBgZGRkaGhobGxscHBwdHR0eHh4fHx8gICAhISEiIiIjIyMkJCQlJSUmJiYnJycoKCgpKSkqKiorKyssLCwtLS0uLi4vLy8wMDAxMTEyMjIzMzM0NDQ1NTU2NjY3Nzc4ODg5OTk6Ojo7Ozs8PDw9PT0+Pj4/Pz9AQEBBQUFCQkJDQ0NERERFRUVGRkZHR0dISEhJSUlKSkpLS0tMTExNTU1OTk5PT09QUFBRUVFSUlJTU1NUVFRVVVVWVlZXV1dYWFhZWVlaWlpbW1tcXFxdXV1eXl5fX19gYGBhYWFiYmJjY2NkZGRlZWVmZmZnZ2doaGhpaWlqampra2tsbGxtbW1ubm5vb29wcHBxcXFycnJzc3N0dHR1dXV2dnZ3d3d4eHh5eXl6enp7e3t8fHx9fX1+fn5/f3+AgICBgYGCgoKDg4OEhISFhYWGhoaHh4eIiIiJiYmKioqLi4uMjIyNjY2Ojo6Pj4+QkJCRkZGSkpKTk5OUlJSVlZWWlpaXl5eYmJiZmZmampqbm5ucnJydnZ2enp6fn5+goKChoaGioqKjo6OkpKSlpaWmpqanp6eoqKipqamqqqqrq6usrKytra2urq6vr6+wsLCxsbGysrKzs7O0tLS1tbW2tra3t7e4uLi5ubm6urq7u7u8vLy9vb2+vr6/v7/AwMDBwcHCwsLDw8PExMTFxcXGxsbHx8fIyMjJycnKysrLy8vMzMzNzc3Ozs7Pz8/Q0NDR0dHS0tLT09PU1NTV1dXW1tbX19fY2NjZ2dna2trb29vc3Nzd3d3e3t7f39/g4ODh4eHi4uLj4+Pk5OTl5eXm5ubn5+fo6Ojp6enq6urr6+vs7Ozt7e3u7u7v7+/w8PDx8fHy8vLz8/P09PT19fX29vb39/f4+Pj5+fn6+vr7+/v8/Pz9/f3+/v7////isF19AAAACXBIWXMAAFxGAABcRgEUlENBAAADtElEQVRIiX2WeUgUURzHf7NpHllpmXiUSZYWZpZa231IgbhBYudqJ2mY0QGFQUGZldBNdhiFJpndFIlEdmcWHVCZEVZm/qFhLV5lqNvu/Hpvjp15s+N+/3jvzff9PvMb3rwLUCtr1QFzfJA7cH5jk3MedDn1I7CPtoo0X1DLZ2n5P1dI15kIcFb4STaVGrkSpgNQDS/ldZEfpl4AqoQ6HeRpoAsCoH+RE1Lq4ZIgSu9mkeI+rqLdvWk5q1WNlBpcEal/bEtpPaZJQV566ob2ydwfT+u7iJWCEfNHRtrCdAmYj8gfc4NIElglOitlZI0+ASk0oJAzkzJbdLhyEankekEGWSiTVYn4a6BkRVopwk/phQDIo8jv94ibQmaMEK3zFHnBJDFEKINnaBRGqBN7LnajrSyEenE8QVY5QkILj2z/iNX1a2VjSy2q9MmLeq8QuqTPdMt8J8/y9qlypgH7820KM4laGxEeip2eFeoXXujrSL1TetGlt2XC3wvhYY9IHENGnetFICBq+BJ8XdWD2D1Eekc1pAj1LdSoezFxDUV2slBbUgz9oicGyWlPwFghSasWQWscgFlq10SDouUwmJQeH5wIskaFnyDqp5+CxAGd9eN0CGxwg5eOhyQFEUd4gx6CJkOL3LSPBI1y9Aje6O/YJK4y4XTBJagirU1S45nyvfx4FeAJw0j5XCHqA0z1N6voMjfCTNm8oc4RAUYW+bvC7wnAe7Qf9oI5kmeLUSNzwUzKgw4iL6bR/0t/998do4k9WzJL1ARkQi4pL8tEAZm9187ODsN82jlLNDtDGeQUlJHSKG9R1vtTuZJHe2MxgXZOF83dDAGvoJmusHlf5Tx85aK26gwMpp3iQDZ6M4RPD/CjaCOwCS18bd3m1NU1QlwkNZOF5hY2SSJZlVlCa0CU10iOriyPQhqXQb1VtGVhk0ABQSpYCwznSKCw8LZS5Djb62EhiHWohnF/TCYVPZsOEMKmOaTMwj6Wq0EgtB35ZaQuJkg528W9EZAW9nQkyrieSKt7yMx6qgUobrAntIikT4jf2SPB+5uE2KbpEgayuvex1lGUEGwYpId42tEezjhJdgeCZXqHWDDiHcaIbkMFwaM6yAQUp5qsSHGLdhyvec6ICZ+od3hjM7IIHnT6tnT7DNXTsg45UrkqVAQBq235SjvosnK/UF1IWtaxidwc/6Tfjg4ljL32fExTdnxFvtnNqJbmctV0aDKbios/rc6ggxBZbu9aGBtI03HBpsOfnfrxP9GxOuVoKeRBAAAAAElFTkSuQmCC"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!--Kalb/Beef -->
				<xsl:if test="$icon_kalb">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Rind/Beef -->
				<xsl:if test="$icon_rind">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Suppe/Soup -->
				<xsl:if test="$icon_suppe">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/>
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Käse/Cheese -->
				<xsl:if test="$icon_kaese">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Pizza -->
				<xsl:if test="$icon_pizza">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Vorspeise / Starter -->
				<xsl:if test="$icon_vorspeisen">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Mediteran -->
				<xsl:if test="$icon_mediterran">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Grillen /Barbeque -->
				<xsl:if test="$icon_grillen">	
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Lamm / Lamb -->
				<xsl:if test="$icon_lamm">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Pasta -->
				<xsl:if test="$icon_pasta">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Chicken -->
				<xsl:if test="$icon_gefluegel">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				<!-- Schwein / Pig -->
				<xsl:if test="$icon_schwein">
				<fo:external-graphic content-width="50" content-height="50" src="data:image/png;base64, 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"/> 
				<xsl:text> </xsl:text>
				</xsl:if>
				</fo:block>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="$isWine" >		
		<!-- Texte 522 x 152 -->
		<fo:block-container position="absolute" top="4px"  width="315px" font-weight="bold" font-family="Frutiger 57Cn">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<!-- Text 1  -->
			<fo:block line-height="1em">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="$artikeltext1FontSizeWine"/>pt</xsl:attribute>
				<xsl:value-of select="@artikeltext1"/>
			</fo:block>
			<!-- Text 2 -->
			<fo:block line-height="1em">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="$artikeltext1FontSizeWine"/>pt</xsl:attribute>
				<xsl:value-of select="@artikeltext2" /> 
			</fo:block>
		</fo:block-container>
	
		<xsl:choose>
		<xsl:when test="$isPage2">
			<fo:block-container position="absolute" top="60px" width="200px" font-weight="bold" font-family="Frutiger 57Cn" font-size="18px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>							
				<fo:block wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@nan" />
				</fo:block>
								
				<fo:block wrap-option="no-wrap" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="@lagerLieferant" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
					
				<!--
				<fo:block wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@ean" />
				</fo:block>	
				-->
			</fo:block-container>
		</xsl:when>
		<xsl:otherwise>
			<fo:block-container position="absolute" top="55px" width="200px" font-weight="bold" font-family="Frutiger 57Cn" font-size="18px">
		    <xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<!-- Inhaltsangabe -->
			
			<xsl:choose>
			<xsl:when test="string-length(@inhaltsangabe) &gt; 30">
				<fo:block line-height="1em" wrap-option="no-wrap">
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<xsl:attribute name="font-size" ><xsl:value-of select="11"/>pt</xsl:attribute>
						<xsl:value-of select="@inhaltsangabe" />
				</fo:block>
			</xsl:when>
			<xsl:when test="string-length(@inhaltsangabe) &gt; 20">
				<fo:block line-height="1em" wrap-option="no-wrap">
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<xsl:attribute name="font-size" ><xsl:value-of select="14"/>pt</xsl:attribute>
						<xsl:value-of select="@inhaltsangabe" />
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:block line-height="1em" wrap-option="no-wrap">
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<xsl:value-of select="@inhaltsangabe" />
				</fo:block>
			</xsl:otherwise>
			</xsl:choose>
			
			<!-- Pfand -->
			<xsl:if test="@leergutPreis != ''" >
				<fo:block line-height="1em" wrap-option="no-wrap" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					+ Pfand <xsl:value-of select="format-number(@leergutPreis, '##0.00')" />
				</fo:block>
			</xsl:if>
			<!-- Grundpreis -->
				<fo:block line-height="1em">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					
					<xsl:choose>
					<xsl:when test="$isPage2">
					<!-- EAN -->
						<xsl:value-of select="@ean" />
					</xsl:when>
					<xsl:when test="@grundPreisPOF != ''">
						<!-- Grundpreis -->
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
					
				</fo:block>
			</fo:block-container>
		</xsl:otherwise>
		</xsl:choose>	

		
		<fo:block-container position="absolute" top="55px" font-family="Frutiger 57Cn" font-weight="bold" width="210px">
			<xsl:attribute name="left"><xsl:value-of select="155 + $isAktion * 25 + 2" />px</xsl:attribute>
			<!-- weinkz  -->
			<fo:block line-height="1em" font-size="16pt" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:value-of select="@weinkz"/>
			</fo:block>
			<!-- winetext: text_2_1 text_2_2 text_2_3 -->
			<fo:block line-height="0.9em">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="$winetextFontSize" /></xsl:attribute>
				<xsl:value-of select="substring($winetext, 1, 115)" /> 
			</fo:block>
		</fo:block-container>
		
		<xsl:choose>
		<xsl:when test="$isAktion">
			<fo:block-container position="absolute" top="122px" width="190px">
			<xsl:attribute name="left"><xsl:value-of select="155 + $isAktion * 25 + 2" />px</xsl:attribute>
			<fo:block line-height="1em" font-size="12px">
			   <fo:external-graphic content-width="170" content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAL4AAAAZCAYAAACPbZTLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAASklEQVR42u3SAQ0AAAjDMMC/5+MDWgnLOkkKnhkJMD4YH4wPxgfjg/HB+GB8MD4YH4wPxgfjg/HB+GB8MD4YH4yP8cH4YHwwPhyyrsEELqbWDpcAAAAASUVORK5CYII="/>
			</fo:block>
	        </fo:block-container >
		
		    <fo:block-container position="absolute" top="126px" width="190px" text-align="center" font-size="14px" >
			<xsl:attribute name="left"><xsl:value-of select="153 + $isAktion * 25 + 2" />px</xsl:attribute>
			<fo:block line-height="1em"  color="black">
			   <xsl:value-of select="@text_11_4"/>
			</fo:block>		
            </fo:block-container >			
		</xsl:when>
		<xsl:otherwise>
			<fo:block-container position="absolute" top="122px" width="190px">
			<xsl:attribute name="left"><xsl:value-of select="155 + $isAktion * 25 + 2" />px</xsl:attribute>
			<fo:block line-height="1em" font-size="12px">
			   <fo:external-graphic content-width="170" content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAL4AAAAZCAYAAACPbZTLAAAACXBIWXMAAAsTAAALEwEAmpwYAAAASklEQVR42u3SAQ0AAAjDsIN/z+ADWgnLKskEnmkJMD4YH4wPxgfjg/HB+GB8MD4YH4wPxgfjg/HB+GB8MD4YH4yP8cH4YHwwPhyyk6wBMblMZhIAAAAASUVORK5CYII="/>
			</fo:block>
	        </fo:block-container>
		
		    <fo:block-container position="absolute" top="126px" width="190px" text-align="center" font-size="14px">
			<xsl:attribute name="left"><xsl:value-of select="153 + $isAktion * 25 + 2" />px</xsl:attribute>
			<fo:block line-height="1em" color="white">
			   <xsl:value-of select="@text_11_4"/>
			</fo:block>
	        </fo:block-container >
		</xsl:otherwise>
		</xsl:choose>
		</xsl:if>	
		</xsl:if>

		<xsl:if test="$isBakery">	
		<fo:block-container position="absolute" top="4px" font-family="Frutiger 57Cn" font-weight="bold" width="230px" >
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
			<!-- Bakery Text  -->
			<xsl:choose>
				<xsl:when test="$isBakerySmall">	
					<xsl:attribute name="font-size"><xsl:value-of select="$text_20_1_FontSizeBakerySmall"/>pt</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>		
					<xsl:attribute name="font-size"><xsl:value-of select="$text_20_1_FontSizeBakery"/>pt</xsl:attribute>	
				</xsl:otherwise>	
			</xsl:choose>
			<fo:block line-height="1em" >
				<xsl:value-of select="@text_20_1"/>
			</fo:block>	
		</fo:block-container>

		<fo:block-container position="absolute" top="41px" font-family="Frutiger 57Cn" font-weight="bold" font-size="18px" width="210px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
			<!-- Inhaltsangabe  -->
			<fo:block line-height="1em">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<xsl:value-of select="@inhaltsangabe"/>
			</fo:block>
			<!-- Grundpreis -->
			<xsl:if test="@grundPreisPOF != '' ">
			<fo:block line-height="1em">
			    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:choose>
				<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
			    <xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
				<!--<fo:inline font-family="Frutiger 57Cn">&#xa0;&#8364;</fo:inline>-->
				€
				</xsl:when>
				<xsl:otherwise>
				<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
				</xsl:otherwise>
				</xsl:choose>
			 </fo:block>
			 </xsl:if>
		</fo:block-container>
		
		<xsl:choose>
		<xsl:when test="$isPage2">
		    <fo:block-container position="absolute" top="4px" width="280px" font-family="Frutiger 57Cn" font-weight="bold" font-size="18pt">	
			<xsl:attribute name="left"><xsl:value-of select="235 + 2" />px</xsl:attribute>							
				<fo:block wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@nan" />
				</fo:block>
							
				<fo:block wrap-option="no-wrap" >
				    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="format-number(@einheit, '####0000')" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="@lagerLieferant" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="format-number(@wagru, '####0000')" />
				</fo:block>
				
				<!--
				<fo:block wrap-option="no-wrap">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:value-of select="@ean" />
				</fo:block>	
				-->
			</fo:block-container>
		</xsl:when>
		<xsl:otherwise>
			<fo:block-container  position="absolute" top="4px" width="280px + $isBakerySmall * 80 - $isAktion * $isBakerySmall * 26" font-family="Frutiger 57Cn" font-weight="bold" wrap-option="wrap">
			<xsl:attribute name="left"><xsl:value-of select="231 + 2 - $isBakerySmall * 80 + $isAktion * $isBakerySmall * 26" />px</xsl:attribute>
			<xsl:attribute name="font-size"><xsl:value-of select="$zutatenFontSize"/>pt</xsl:attribute>
			<xsl:attribute name="font-weight"><xsl:value-of select="$zutatenFontWeight"/></xsl:attribute>
			<!-- Bakery Text  -->
			<fo:block>
				<xsl:attribute name="color"><xsl:value-of select="$fontColor"/></xsl:attribute>
				<fo:block >
				  <xsl:value-of select="$zutaten"/>
				</fo:block>
			</fo:block>
		</fo:block-container>
		</xsl:otherwise>
		</xsl:choose>

		<!-- Nutriscore -->		
		<xsl:choose>
		<xsl:when test="$isNutriScore and $isNoWine and $isNoBakery">
			<fo:block-container position="absolute" top="80px" width="108px">
			<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 4" />px</xsl:attribute>
			
			<xsl:choose>
			<xsl:when test="$isAktion">
					<fo:block line-height="1em">					
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					</fo:block>	
			</xsl:when>
			<xsl:otherwise>
					<fo:block line-height="1em">
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					</fo:block>	
			</xsl:otherwise>
			</xsl:choose>
			</fo:block-container>
			
			<!-- Schnelldreherpunkt und R -->
			<fo:block-container position="absolute" top="155px" left="185px" width="12px"  color="black" >
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<!--<fo:block line-height="2px" font-size="17pt" font-weight="normal">R</fo:block>-->
			<fo:block>
				<xsl:if test="@schnelldreher = 'true'">
					<fo:instream-foreign-object>
					<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
						<circle cx="6" cy="6" fill="black" r="6" />
					</svg>
					</fo:instream-foreign-object>	
				</xsl:if>
			</fo:block>
			
			<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="20pt" font-weight="bold" color="black">
			<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
				R
			</xsl:if>
			</fo:block>	
			</fo:block-container>	
		</xsl:when>
		<xsl:otherwise>
			<!-- Schnelldreherpunkt und R -->
			<fo:block-container position="absolute" top="75px" width="12px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 5 " />px</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<fo:block>
					<xsl:if test="@schnelldreher = 'true'">
					<fo:instream-foreign-object>
						<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
							<circle cx="6" cy="6" fill="black" r="6" />
						</svg>
					</fo:instream-foreign-object>	
					</xsl:if>
				</fo:block>
				<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold" color="black">
					<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
						R
					</xsl:if>
				</fo:block>	
			</fo:block-container>		
		</xsl:otherwise>
		</xsl:choose>
		
		
		<!-- Barcode intl2of5 <xsl:value-of select="$fontColor"/> <xsl:attribute name="color"><xsl:value-of select="$barcode"/></xsl:attribute> yyyyyyyy -->
		<xsl:if test="@barcode != ''"> 
		
		     <fo:block-container position="absolute" left="24px" height="29px" top="106px" background-color="white">
			   <xsl:attribute name="width"><xsl:value-of select="85 - $preiseuro2Digits * $isAktion * 15 - $preiseuro2Digits * $isAktion * $isBakerySmall * 15" />px</xsl:attribute>			
				 <fo:block> </fo:block>
			 </fo:block-container>
			 
			 <fo:block-container position="absolute" top="108px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3"/>px</xsl:attribute>
					
					<xsl:choose>
					<xsl:when test="$isBakerySmall">
						<fo:block line-height="0.9em">
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>2</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
						</fo:block>	
					</xsl:when>
					<xsl:otherwise>
						<fo:block line-height="0.9em">
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
						</fo:block>	
					</xsl:otherwise>
					</xsl:choose>
			</fo:block-container>	
		</xsl:if>
		<xsl:if test="@ean != ''">
			 <fo:block-container position="absolute" top="140px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3" />px</xsl:attribute>
			    <fo:block font-size="14pt" line-height="0.9em">
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3" />px</xsl:attribute>
					<xsl:value-of select="@ean"/>
				</fo:block>	
			</fo:block-container>

		</xsl:if>
		
	</xsl:if>
		


		<!-- Standard - No Wine -->
		<xsl:if test="$isNoWine and $isNoBakery">
		    <!-- Texte -->
			<fo:block-container position="absolute" top="4px" font-family="Frutiger 57Cn" font-size="20pt" font-weight="bold">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
				<!-- Text 1 / Text 2 -->
				<!-- Der Text darf nicht brechen, da er sonst mit dem Grundpreis ueberlappen wuerde. -->
				<!-- Daher wird die maximale Schriftgroesse berechnet. -->
				<fo:block line-height="1em" font-size="25pt" wrap-option="no-wrap" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize"/>pt</xsl:attribute>
					<xsl:value-of select="$text1and2" />
				</fo:block>
				<!-- Text 3 -->
				<fo:block line-height="1em" wrap-option="no-wrap" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="@artikeltext3" />
				</fo:block>
				<!-- Inhaltsangabe -->
				<fo:block line-height="1em" wrap-option="no-wrap" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="@inhaltsangabe" />
				</fo:block>
				<!-- Pfand -->
				<xsl:if test="@leergutPreis!=''" >
					<fo:block line-height="1em" wrap-option="no-wrap" >

					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						+ Pfand <xsl:value-of select="format-number(@leergutPreis, '##0.00')" />
					</fo:block>
				</xsl:if>
			</fo:block-container>
			
			<xsl:choose>
			<xsl:when test="$isPage2">
				<fo:block-container position="absolute" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold" line-height="0.9em" top="60px">			   
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
									
					<fo:block wrap-option="no-wrap">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="@nan" />
					</fo:block>
						
					<fo:block wrap-option="no-wrap" >
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<xsl:value-of select="format-number(@einheit, '####0000')" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="@lagerLieferant" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="format-number(@wagru, '####0000')" />
					</fo:block>
					
					<fo:block wrap-option="no-wrap">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="@ean" />
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<!-- Grundpreis -->
				<xsl:if test="@grundPreisPOF != '' and (not(@meCode) or @meCode = '')">
					<fo:block-container position="absolute" top="66px" font-family="Frutiger 57Cn" font-weight="bold" font-size="18px">
						<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
						<fo:block >

					    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
							<xsl:choose>
								<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
									<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
									<!--<fo:inline font-family="Frutiger 57Cn">&#xa0;&#8364;</fo:inline>-->
									€
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</fo:block-container>
				</xsl:if>
				<xsl:if test="@grundPreisPOF != '' and @meCode != ''">
					<fo:block-container position="absolute" top="66px" left="3" >
						<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 2" />px</xsl:attribute>
						<!-- Inhalt POF -->
						<fo:block font-family="Frutiger 57Cn" font-weight="bold"  font-size="18px">
					        <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
							<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
						</fo:block>
					</fo:block-container>
				</xsl:if>
			</xsl:otherwise></xsl:choose>
		</xsl:if>
	
		
		

		<!-- Barcode intl2of5 <xsl:value-of select="$fontColor"/> <xsl:attribute name="color"><xsl:value-of select="$barcode"/></xsl:attribute>-->
		<xsl:if test="@barcode != '' and $isNoBakery"> 
		
			<fo:block-container position="absolute" left="24px" height="29px" top="106px" width="83px" background-color="white">
				 <fo:block> </fo:block>
			 </fo:block-container>
			 
			 <fo:block-container position="absolute" top="107px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3"/>px</xsl:attribute>
					<fo:block>
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>12</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>2</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
					</fo:block>
			</fo:block-container>

			<fo:block-container position="absolute" top="136px">
				<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + 3"/>px</xsl:attribute>
				<fo:block font-size="17pt">
					<xsl:value-of select="@ean"/>
				</fo:block>	
			</fo:block-container>
			
		</xsl:if>

		<xsl:choose>
		<xsl:when test="$isPage2">
		</xsl:when>
		<xsl:otherwise>
		<!-- Schnelldreherpunkt und R -->
			<xsl:if test="$isNoWine and $isNoBakery"> 
				<xsl:if test="$isNutriScore">
					<fo:block-container position="absolute" top="120px" left="230" width="108px">
					<xsl:attribute name="left"><xsl:value-of select="210 + $isAktion * 25" />px</xsl:attribute>			
					<xsl:choose>
					<xsl:when test="$isAktion">
					
						<fo:block line-height="1em">
						<xsl:if test="@nutriScore = 'A'">
							<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'B'">
							<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'C'">
							<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'D'">
							<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'E'">
							<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
			"/>
						</xsl:if>
						</fo:block>				
					</xsl:when>
					<xsl:otherwise>
					<fo:block line-height="1em">					
						<xsl:if test="@nutriScore = 'A'">
							<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
			"/>
						</xsl:if>
						<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC				
			"/>
						</xsl:if>
					</fo:block>	
					</xsl:otherwise>
					</xsl:choose>			
					</fo:block-container>
				</xsl:if>
			</xsl:if>
			
			<xsl:choose>
			<xsl:when test="$isNoBakery and $isNoWine"> 
				<fo:block-container position="absolute" top="117px" width="12px" color="black">
				<xsl:attribute name="left"><xsl:value-of select="140 + $isAktion * 25 +2 " />px</xsl:attribute>
				<fo:block>
					<xsl:if test="@schnelldreher = 'true'">
					<fo:instream-foreign-object>
						<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
							<circle cx="6" cy="6" fill="black" r="6" />
						</svg>
					</fo:instream-foreign-object>	
					</xsl:if>
				</fo:block>
				<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" color="black">
					<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
						R
					</xsl:if>
				</fo:block>	
				</fo:block-container>
				
				<xsl:if test="string-length(@lagerLieferant) &gt; 0">
					<fo:block-container position="absolute" top="136px" width="12px" color="black">
					<xsl:attribute name="left"><xsl:value-of select="140 + $isAktion * 25 + 3 + $isDreherOrRaemung * 20" />px</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" color="black">
						<xsl:value-of select="@lagerLieferant"/>
					</fo:block>	
					</fo:block-container>
				</xsl:if>
			</xsl:when>		
			<xsl:when test="$isNoBakery">
				<fo:block-container position="absolute" top="119px" width="12px">
				<xsl:attribute name="left"><xsl:value-of select="140 + $isAktion * 25 +2 " />px</xsl:attribute>
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<fo:block>
					<xsl:if test="@schnelldreher = 'true'">
					<fo:instream-foreign-object>
						<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
							<circle cx="6" cy="6" fill="black" r="6" />
						</svg>
					</fo:instream-foreign-object>	
					</xsl:if>
				</fo:block>
				<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold" color="black">
					<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
						R
					</xsl:if>
				</fo:block>	
				</fo:block-container>
				
				<fo:block-container position="absolute" width="100px" color="black" text-align="right">
					<xsl:attribute name="top"><xsl:value-of select="102" />px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="52 + $isAktion * 25 +2" />px</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" color="black">
						<xsl:value-of select="@lagerLieferant"/>
					</fo:block>	
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block-container position="absolute" top="137px" width="12px" color="black">
					<xsl:attribute name="top"><xsl:value-of select="95 + $hasNoBarcode * 27" />px</xsl:attribute>
					<xsl:attribute name="left"><xsl:value-of select="$isAktion * 25 + $isDreherOrRaemung * 25 + 3" />px</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="15pt" color="black">
						<xsl:value-of select="@lagerLieferant"/>
					</fo:block>	
				</fo:block-container>
			</xsl:otherwise>
			
			</xsl:choose>
			
		</xsl:otherwise>
		</xsl:choose>

		
		

		


		<fo:block-container position="absolute" text-align="right">
			<xsl:attribute name="top"><xsl:value-of select="64 - $isBottle * 15 + $isBakerySmall * 22 - $isFW * 27 + $isFW * $isWine * 10 - $isBakery * 5"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="39 - $isBottle * 8 + $isBakerySmall * 61 + $isBakery * 298 - $isAktion * $isBakerySmall * 26 - $isFW * $isWine * 10"/>px</xsl:attribute>
			<fo:block font-family="REWE Preisschrift" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size"><xsl:value-of select="92 - $isBottle * 24 - $isBakerySmall * 28 - $isFW * $isWine * 20"/>pt</xsl:attribute>
				<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="48 - $isBottle * 12"/>pt</xsl:attribute>
				</fo:inline>
				<fo:inline><xsl:value-of select="$preiseuro" />.</fo:inline>
			</fo:block>
		</fo:block-container>
		<!-- Cent-Betrag, höhergestellt -->
		<fo:block-container position="absolute" text-align="right" >
			<xsl:attribute name="top"><xsl:value-of select="64 - $isBottle * 15  + $isBakerySmall * 22 - $isFW * 28 + $isFW * $isWine * 13 - $isBakery * 5"/>px</xsl:attribute>
			<xsl:attribute name="right"><xsl:value-of select="1 + $isBakery * 298 + $isBakerySmall * 73 - $isAktion * $isBakerySmall * 26"/>px</xsl:attribute>
			<!--<xsl:attribute name="left"><xsl:value-of select="254 + $isBottle * 4"/>px</xsl:attribute>-->
			<fo:block font-family="REWE Preisschrift" >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				<xsl:attribute name="font-size" ><xsl:value-of select="92 - $isBottle * 24 - $isBakerySmall * 28 - $isFW * $isWine * 30 "/>pt</xsl:attribute>
				<xsl:value-of select="$preiscent" />
			</fo:block>
		</fo:block-container>

		<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwPreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwPreisCharacteristic" select="substring-before($fwPreis, '.')" />
			<xsl:variable name="fwPreisMantissa" select="translate(substring(substring-after($fwPreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<fo:block-container position="absolute" text-align="right" color="white" overflow="hidden">
				<xsl:attribute name="top"><xsl:value-of select="87 - $isBottle * 27 + $isFW * 28 "/>px</xsl:attribute>
				<xsl:attribute name="height"><xsl:value-of select="39 - $isBottle * 10"/>px</xsl:attribute>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="42 - $isBottle * 12 - $isWine * 9"/>pt</xsl:attribute>
					<!--<fo:inline padding="3px 2px 0px 1px" background-color="black">-->
					<fo:inline padding="3px 1px 12px 1px" >
						<!-- Left part of dot -->
						<fo:inline font-family="Frutiger 57Cn" font-weight="bold" max-height="10px" >
							<xsl:attribute name="background-color"><xsl:value-of select="$bckColor" /></xsl:attribute>
							<xsl:attribute name="font-size"><xsl:value-of select="18 - $isBottle * 6 - $isWine * 6"/>pt</xsl:attribute>
							<xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung" />
						</fo:inline>
						<xsl:value-of select="$fwPreisCharacteristic" />
						<xsl:value-of select="$fwPreisMantissa" />
					</fo:inline>
			</fo:block>
			</fo:block-container>
			<!--
			<fo:block-container position="absolute" color="white">
				<xsl:attribute name="top"><xsl:value-of select="87 - $isBottle * 27"/>px</xsl:attribute>
				<xsl:attribute name="left"><xsl:value-of select="265 + $isBottle * 8"/>px</xsl:attribute>
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="43 - $isBottle * 12 - $isWine * $isFW * 8"/>pt</xsl:attribute>
				</fo:block>
			</fo:block-container>
			-->
		</xsl:if>
		
		
		<!-- Pfandangabe Einweg / Mehrweg -->
		<xsl:if test="$isBottle">
			<fo:block-container  position="absolute" top="108px" text-align="right" font-family="Frutiger 57Cn" font-size="46pt" font-weight="bold" color="#ffffff">
				<xsl:attribute name="left"><xsl:value-of select="112 + $isAktion * 25"/>px</xsl:attribute>
				<fo:block >
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:choose><xsl:when test="@leergutKz = 'B'">
						<xsl:attribute name="letter-spacing">-2pt</xsl:attribute>
						MEHRWEG
					</xsl:when><xsl:when test="@leergutKz = 'P'">
						EINWEG
					</xsl:when></xsl:choose>
				</fo:block>
			</fo:block-container>
		</xsl:if>
    </xsl:template>
	  
	  
	  
	  
	  
	  

	<xsl:template name="ETIKETT42">
      <xsl:variable name="isAktion" select="@versTextZahl = 'A'"/>
      <xsl:variable name="isFW" select="string-length(/LISTE/JSON_TAGs/@FW_Preis) &gt; 0 and string-length(/LISTE/JSON_TAGs/@FW_Waehrung) &gt; 0" />
      <xsl:variable name="meCode" select="@mecode = 'kg'"/>
      <xsl:variable name="smartShoppen" select="@smartshoppen = 'J'"/>
	  <xsl:variable name="isNutriScore" select="string-length(@nutriScore) &gt; 0"/>
	  <xsl:variable name="hasNoBarcode" select="string-length(@barcode) &lt; 1"/>
	  <xsl:variable name="hasText3" select="string-length(@text3) &gt; 0"/>
	  
	  <xsl:variable name="nanLength">
	    <xsl:value-of select="string-length(@nan)"/>
	  </xsl:variable>
	  
	  <xsl:variable name="isText6Long" select="string-length(@text6) &gt; 24 and not(contains(@text6, ' '))" />
	  <xsl:variable name="isText7Long" select="string-length(@text7) &gt; 24 and not(contains(@text7, ' '))" />


	  <!--
	  <xsl:variable name="isText6Long" select="string-length(@text6) &gt; 0 and 'J' = 'J'" />
	  <xsl:variable name="isText7Long" select="string-length(@text7) &gt; 17 and 'J' = 'J'" />
	  -->
	  
      <xsl:variable name="wiegepflichtig" select="@wiegepflichtig = 'J'"/>
      <xsl:variable name="Image" select="/LISTE/IMAGE"/>
	  <xsl:variable name="isPage2" select="/LISTE/JSON_TAGs/@Template='P2' or /LISTE/JSON_TAGs/@Template='p2'"/>
	  <xsl:variable name="isEAN" select="string-length(@ean) &gt; 0"/>
	  
	  <xsl:variable name="text1and2">
	    <xsl:value-of select="substring(@text1, 1, 16)"/><xsl:text> </xsl:text><xsl:value-of select="substring(@text2, 1, 16)" />
	  </xsl:variable>
	  	
		<xsl:variable name="text1and2FontSize">
		  <xsl:choose>
			<xsl:when test="string-length($text1and2) &gt; 47">18</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 41">20</xsl:when>
			<xsl:when test="string-length($text1and2) &gt; 30">23</xsl:when>	    
			<xsl:when test="string-length($text1and2) &gt; 19">25</xsl:when>
			<xsl:otherwise>35</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="text1and2FontSizeSS">
		  <xsl:choose>
			<xsl:when test="string-length($text1and2) &gt; 26">23</xsl:when>	    
			<xsl:when test="string-length($text1and2) &gt; 12">25</xsl:when>
			<xsl:otherwise>35</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="fontColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A'">
		      WHITE
		    </xsl:when>
		    <xsl:otherwise>
			  BLACK
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>
		<xsl:variable name="bckColor">
		  <xsl:choose>
		    <xsl:when test="@versTextZahl = 'A'">
		      RED
		    </xsl:when>
		    <xsl:otherwise>
			  WHITE
			</xsl:otherwise>
		  </xsl:choose>
		</xsl:variable>

	  <fo:block-container position="absolute" left="0px" top="0px" width="400px" height="300px" background-color="{$bckColor}" text-align="center" line-height="21px" >
		<fo:block></fo:block>	
	  </fo:block-container>
	  
      <!-- smartShoppen -->            
      <xsl:if test="$smartShoppen">
     
      <fo:block-container position="absolute" left="230px" >
	    <xsl:attribute name="top"><xsl:value-of select="45 -$isFW * 15" />px</xsl:attribute>
        <fo:block position="absolute" >
           <fo:external-graphic content-width="169" content-height="149" src="data:image/png;base64,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"/>
        </fo:block>
      </fo:block-container>
          
      <xsl:choose>
         <xsl:when test="@meCode = 'kg' and @wiegepflichtig = 'J'">
            <fo:block-container position="absolute" top="125px" left="255px" font-family="Frutiger 57Cn" font-size="16pt" font-weight="bold" >
                 <fo:block color="#000000">
                 Bitte an Waage auszeichnen!
                 </fo:block>
            </fo:block-container>
         </xsl:when>
	 
         <xsl:when test="( (string-length(@barcode_2) > 1) and  not (@meCode = 'kg' and @wiegepflichtig = 'J') )">
         <fo:block-container position="absolute" top="115px" left="275px" font-family="Frutiger 57Cn" font-size="16pt" font-weight="bold">
                  <fo:block color="#000000">
                  Hier scannen!
               </fo:block>
         </fo:block-container>      

         <fo:block-container position="absolute" top="130px" left="240px" width="157" text-align="center">
            <fo:block>
               <fo:instream-foreign-object>
                  <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode_2}">
                     <barcode:code128>
                        <barcode:height>50pt</barcode:height>
                        <barcode:module-width>0.02in</barcode:module-width>
                        <barcode:wide-factor>4</barcode:wide-factor>
                        <barcode:human-readable>
                           <barcode:placement>none</barcode:placement>
                        </barcode:human-readable>
                     </barcode:code128>
                  </barcode:barcode>
               </fo:instream-foreign-object>
            </fo:block>
         </fo:block-container>
         </xsl:when>
		 
         <xsl:otherwise>
               <xsl:if test="@ean">
                  <xsl:choose><xsl:when test="( ((string-length(@ean) = 12 or string-length(@ean) = 13)) and  not (@meCode = 'kg' and @wiegepflichtig = 'J') )">
                     <fo:block-container position="absolute" top="115px" left="275px" font-family="Frutiger 57Cn" font-size="16pt" font-weight="bold">
                        <fo:block color="#000000" >
                           Hier scannen!
                        </fo:block>
                     </fo:block-container>
                  <fo:block-container  position="absolute" top="130px" left="240px" width="157" text-align="center">
                     <fo:block>
                     <fo:instream-foreign-object>
                        <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@ean}">
                           <barcode:ean13>
                              <barcode:height>50pt</barcode:height>
                              <barcode:module-width>0.02in</barcode:module-width>
                              <barcode:wide-factor>4</barcode:wide-factor>
                              <barcode:human-readable>
                                 <barcode:placement>none</barcode:placement>
                              </barcode:human-readable>
                           </barcode:ean13>
                        </barcode:barcode>
                     </fo:instream-foreign-object>
                  </fo:block></fo:block-container>
                  </xsl:when>
                  <xsl:when test="((string-length(@ean) = 7 or string-length(@ean) = 8)) and  not (@meCode = 'kg' and @wiegepflichtig = 'J') ">
                  <fo:block-container position="absolute" top="115px" left="275px" font-family="Frutiger 57Cn" font-size="16pt" font-weight="bold">
                        <fo:block color="#000000">
                           Hier scannen!
                        </fo:block>
                  </fo:block-container>
                  <fo:block-container  position="absolute" top="130px" left="263px" width="157" text-align="center">
                     <fo:block>
                     <fo:instream-foreign-object>
                        <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@ean}">
                           <barcode:ean8>
                              <barcode:height>50pt</barcode:height>
                              <barcode:module-width>0.02in</barcode:module-width>
                              <barcode:wide-factor>4</barcode:wide-factor>
                              <barcode:human-readable>
                                 <barcode:placement>none</barcode:placement>
                              </barcode:human-readable>
                           </barcode:ean8>
                        </barcode:barcode>
                     </fo:instream-foreign-object>
                  </fo:block>
				  </fo:block-container>
                  </xsl:when>
                  </xsl:choose>
               </xsl:if>
         </xsl:otherwise> 
      </xsl:choose>
      </xsl:if>
      
      <!-- Aktionsbalken -->
      <xsl:if test="$isAktion">
         <fo:block-container position="absolute" left="0px" right="0px" top="0px" height="44px" background-color="{$fontColor}" font-family="Unit Rounded Offc Black" text-align="center" font-size="50pt" color="{$bckColor}" line-height="50pt">
            <fo:block>
               AKTION
            </fo:block>
         </fo:block-container>
      </xsl:if>
	  
	  
	  <xsl:choose>
	  <xsl:when test="$smartShoppen">
	     <!-- Texte -->
         <fo:block-container position="absolute" left="3px" line-height="150%" font-family="Frutiger 57Cn" font-size="25pt" font-weight="bold">
         <xsl:attribute name="top"><xsl:value-of select="$isAktion * 42 + 6" />px</xsl:attribute>
		 <xsl:attribute name="right"><xsl:value-of select="$isAktion * 170"/>px</xsl:attribute>

         <!-- Text 1 / Text 2 -->
         <fo:block line-height="1em">
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSizeSS" /></xsl:attribute>
            <xsl:value-of select="$text1and2" />
            <fo:leader/>
         </fo:block>
		 </fo:block-container>

		<fo:block-container position="absolute" left="3px" right="167px" font-family="Frutiger 57Cn" font-size="20pt" font-weight="bold">
		<xsl:attribute name="top"><xsl:value-of select="$isAktion * 42 + 52" />px</xsl:attribute>
         <!-- Text 3 -->	
		 
		 <xsl:choose>
         <xsl:when test="@text3 != '' ">
         <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
            <xsl:if test="$isAktion">
               <xsl:attribute name="line-height">120%</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="substring(@text3, 1, 50)" />
            <fo:leader />
         </fo:block>
		 </xsl:when>

		 <xsl:when test="(@text6 != '' and @text7 != '') or (@text5 != '' and @text7 != '') or (@text5 != '' and @text6 != '')">		 
		 </xsl:when>
		 
		 <xsl:otherwise>
		 <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
            <xsl:if test="$isAktion">
               <xsl:attribute name="line-height">120%</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="substring(@text3, 1, 50)" />
            <fo:leader />
         </fo:block>
		 </xsl:otherwise>
		 
		 </xsl:choose>
		 
         <!-- Text 4 / Text 5 -->
         <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			
			<xsl:choose>
			<xsl:when test="contains(@text4, 'Deklaration lt.')">
			   <xsl:text>Deklaration s. Etikett</xsl:text>
			</xsl:when>
			<xsl:when test="contains(@text4, 'Deklaration siehe')">
			   <xsl:text>Deklaration s. Etikett</xsl:text>
			</xsl:when>
			<xsl:when test="contains(@text4, 'Deklaration s.')">
			   <xsl:text>Deklaration s. Etikett</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			   <xsl:value-of select="substring(@text4, 1, 40)" />			
			</xsl:otherwise>
			</xsl:choose>
            <fo:leader />
         </fo:block>
		
		<xsl:if test="@text5 != ''">
		  <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
		    <xsl:value-of select="substring(@text5, 1, 40)" />			
		  </fo:block> 		 
		</xsl:if>
		
		<!-- Text 6 -->
		<xsl:if test="@text6 != '' and not($isPage2)" >
			<xsl:choose>
			<xsl:when test="string-length(@text6) &lt; 30 and not(contains(@text6, ' '))">
			   <fo:block line-height="1em" font-size="14pt">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:value-of select="substring(@text6, 1, 30)" />
			    </fo:block>
			</xsl:when>	
			<xsl:when test="string-length(@text6) &gt; 24 and not(contains(@text6, ' '))">
			   <fo:block line-height="1em" font-size="12pt">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:value-of select="substring(@text6, 1, 35)" />
			    </fo:block>
			</xsl:when>				
			<xsl:when test="contains(@text6, 'www.berliner.vereinbarung.de')">
			   <fo:block line-height="1em" font-size="12pt">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:text>Gem. www.berliner.vereinbarung.de</xsl:text>
			    </fo:block>
			</xsl:when>		
			<xsl:when test="contains(@text6, 'Thiabendazol,imazalil,gewachst')">
			   <fo:block line-height="1em">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:text>Thiabendazol, imazalil, gewachst</xsl:text>
			    </fo:block>
			</xsl:when>	
			<xsl:when test="contains(@text6, 'Thiabendazol,OPP,Imazalil,Pyrimethanil,')">
			   <fo:block line-height="1em">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:text>Thiabendazol, OPP, Imazalil, Pyrimethanil, </xsl:text>
			   </fo:block>
			</xsl:when>				
			<xsl:otherwise>
			  <fo:block line-height="1em" >
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:value-of select="substring(@text6, 1, 40)" /> 
               </fo:block>
			</xsl:otherwise>
			</xsl:choose>   
		</xsl:if>
		
		 <xsl:if test="@text7 != '' and not($isPage2)">
         <!-- Text 7 -->
		 <xsl:choose>
			<xsl:when test="string-length(@text7) &lt; 30 and not(contains(@text7, ' '))">
			   <fo:block line-height="1em" font-size="14pt">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:value-of select="substring(@text7, 1, 30)" />
			    </fo:block>
			</xsl:when>	
			<xsl:when test="string-length(@text7) &gt; 24 and not(contains(@text7, ' '))">
			   <fo:block line-height="1em" font-size="12pt">
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:value-of select="substring(@text7, 1, 35)" />
			    </fo:block>
			</xsl:when>				    			
		    <xsl:otherwise>
			   <fo:block line-height="1em">
				 <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				 <xsl:value-of select="substring(@text7, 1, 40)" />
				 <fo:leader />
			   </fo:block>
		    </xsl:otherwise>
		</xsl:choose>  		 
		</xsl:if>
		
		<xsl:if test="not($isAktion) and not($isPage2)">
		<fo:block linefeed-treatment="preserve" >
			<xsl:text>			
			</xsl:text> 
		</fo:block>
		</xsl:if>
		
		<xsl:if test="$isAktion and not($isPage2)">
		<fo:block linefeed-treatment="preserve" line-height="0.5em" >
			<xsl:text>			
			</xsl:text> 
		</fo:block>
		</xsl:if>

		 
		<xsl:if test="@inhaltsangabe != '' and not($isPage2)">
		<fo:block line-height="1em">
		   <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
		   <xsl:value-of select="@inhaltsangabe" />
		   <fo:leader />
		</fo:block>
		</xsl:if>
		
		<!-- Grundpreis -->			 
		<xsl:if test="@grundPreisPOF != '' and not($isPage2)">
		  <fo:block line-height="1em">
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>

			<xsl:choose>
				<xsl:when test="$isPage2">
					<xsl:value-of select="@ean" />
				</xsl:when>
				<xsl:when test="@grundPreisPOF != ''">
					<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>

		   </fo:block>
		</xsl:if>
		 
		 </fo:block-container> 
	  </xsl:when>

	<!-- NEW: -->
	<!-- kein Smartshoppen -->


	 <xsl:otherwise>
      <!-- Texte -->
      <fo:block-container position="absolute" left="3px" font-family="Frutiger 57Cn" font-weight="bold" font-size="20pt">
         <xsl:attribute name="top"><xsl:value-of select="$isAktion * 42 + 6" />px</xsl:attribute>

         <!-- Text 1 / Text 2 -->
         <fo:block line-height="1em" font-family="Frutiger 57Cn" font-weight="bold">
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<xsl:attribute name="font-size"><xsl:value-of select="$text1and2FontSize" /></xsl:attribute>
			
            <xsl:value-of select="substring(@text1, 1, 32)" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring(@text2, 1, 32)" />
			
            <fo:leader />
         </fo:block>

         <!-- Text 3 -->
		 <xsl:choose>
		 
		 <xsl:when test="@text3 != '' ">
         <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
            <xsl:if test="$isAktion">
               <xsl:attribute name="line-height">120%</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="substring(@text3, 1, 50)" />
            <fo:leader />
         </fo:block>
		 </xsl:when>

		 <xsl:when test="(@text6 != '' and @text7 != '') or (@text5 != '' and @text7 != '') or (@text5 != '' and @text6 != '')">		 
		 </xsl:when>
		 
		 <xsl:otherwise>
		 <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
            <xsl:if test="$isAktion">
               <xsl:attribute name="line-height">120%</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="substring(@text3, 1, 50)" />
            <fo:leader />
         </fo:block>
		 </xsl:otherwise>
		 
		 </xsl:choose>
		 

         <!-- Text 4 / Text 5 -->
         <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			
			<xsl:choose>
			<xsl:when test="contains(@text4, 'Deklaration lt.')">
			   <xsl:text>Deklaration s. Etikett</xsl:text>
			</xsl:when>
			<xsl:when test="contains(@text4, 'Deklaration siehe')">
			   <xsl:text>Deklaration s. Etikett</xsl:text>
			</xsl:when>
			<xsl:when test="contains(@text4, 'Deklaration s.')">
			   <xsl:text>Deklaration s. Etikett</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			   <xsl:value-of select="substring(@text4, 1, 30)" />			
			</xsl:otherwise>
			</xsl:choose>
            <fo:leader />
         </fo:block>
		 
		 <xsl:if test="@text5 != ''">
		  <fo:block line-height="1em" >
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
		    <xsl:value-of select="substring(@text5, 1, 50)" />			
		  </fo:block> 
		 </xsl:if>

		<!-- Text 6 -->
		<xsl:if test="@text6 != ''" >
			<xsl:choose>
			<xsl:when test="contains(@text6, 'www.berliner.vereinbarung.de')">
			   <fo:block line-height="1em" >
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:text>Gem. www.berliner.vereinbarung.de</xsl:text>
			   </fo:block>
			</xsl:when>				
			<xsl:otherwise>
			  <fo:block line-height="1em" >
		       <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			   <xsl:value-of select="substring(@text6, 1, 80)" /> 
               </fo:block>
			</xsl:otherwise>
			</xsl:choose>   
		</xsl:if>

		 <!-- Text 7 -->
         <xsl:if test="@text7 != ''">
         <fo:block line-height="1em">
		    <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
            <xsl:value-of select="substring(@text7, 1, 80)" />
			<xsl:value-of select="@inhaltsangabe" />
            <fo:leader />
         </fo:block>
		 </xsl:if>
			 
      </fo:block-container>
      </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
			<xsl:when test="$isPage2">
				<fo:block-container position="absolute" font-family="Frutiger 57Cn" font-size="20pt" font-weight="bold" left="3" line-height="0.9em">
					<xsl:attribute name="top"><xsl:value-of select="190 + $isAktion * 15" />px</xsl:attribute>
					<fo:block wrap-option="no-wrap">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<!--
					<xsl:value-of select="@nan" />
					-->
					</fo:block>
						
					<fo:block wrap-option="no-wrap" >
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<xsl:value-of select="format-number(@einheit, '####0000')" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="@lagerLieferant" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="format-number(@wagru, '####0000')" />
					</fo:block>
					
					<fo:block wrap-option="no-wrap">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:value-of select="@ean" />
					</fo:block>
					
					
					
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
			
				<!-- IF NOT Smartshopping -->
				<xsl:choose>
				<xsl:when test="$smartShoppen != 'J' ">
				  <!-- Inhaltsangabe und Grundpreis -->
				  <fo:block-container position="absolute" left="3px" font-family="Frutiger 57Cn" font-weight="bold" font-size="22pt">
					
						
						
						<xsl:choose>
						<xsl:when test="(@text4 != '' and @text5 != '' and string-length(@text6) &gt; 14 and @text7 != '')">		 
							 <xsl:attribute name="top"><xsl:value-of select="170 + $hasText3 * 20 + $isAktion * 44" />px</xsl:attribute>
						</xsl:when>
						<xsl:when test="(@text4 != '' and @text5 != '' and string-length(@text6) &gt; 14 and string-length(@text7) &gt; 22)">		 
							 <xsl:attribute name="top"><xsl:value-of select="170 + $hasText3 * 20 + $isAktion * 44" />px</xsl:attribute>
						</xsl:when>
						<xsl:when test="(@text4 != '' and @text5 != '' and string-length(@text6) &gt; 14)">		 
							 <xsl:attribute name="top"><xsl:value-of select="170 + $hasText3 * 20 + $isAktion * 44" />px</xsl:attribute>
						</xsl:when>
						<xsl:when test="(@text4 != '' and @text5 != '' and string-length(@text7) &gt; 14)">		 
							 <xsl:attribute name="top"><xsl:value-of select="170 + $hasText3 * 20 + $isAktion * 44" />px</xsl:attribute>
						</xsl:when>				
						<xsl:when test="(@text4 != '' and string-length(@text6) &gt; 22 and string-length(@text7) &gt; 22)"> 
							 <xsl:attribute name="top"><xsl:value-of select="170 + $hasText3 * 20 + $isAktion * 44" />px</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							 <xsl:attribute name="top"><xsl:value-of select="110 + $hasText3 * 20 + $isAktion * 44" />px</xsl:attribute>
						</xsl:otherwise>
						</xsl:choose>
						

					 <!-- Inhaltsangabe -->
					 <fo:block line-height="1em">
						<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
						<xsl:value-of select="@inhaltsangabe" />
					 </fo:block>
					 
					 <!-- Grundpreis -->
					 
					<fo:block line-height="1em">
					   <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>

					<xsl:choose>
					<xsl:when test="$isPage2">
	
						<xsl:value-of select="@ean" />
					</xsl:when>
					<xsl:when test="@grundPreisPOF != ''">
						<xsl:choose>
						<xsl:when test="contains(@grundPreisPOF, '?')">
							<xsl:choose>
								<xsl:when test="@meCode != ''">
									<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="contains(@grundPreisPOF, '&#8364;') or contains(@grundPreisPOF, '?')">
										<xsl:value-of select="substring-before(translate(@grundPreisPOF, '?()', '&#8364;'), '&#8364;')" />
										€
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="translate(@grundPreisPOF, '?()', '&#8364;')" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>		
						</xsl:when>
						<xsl:otherwise>
                			<xsl:value-of select="@grundPreisPOF"/>				
						</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					</xsl:choose>

					 </fo:block>
		
				  </fo:block-container>
			</xsl:when>
			</xsl:choose>
				  
			</xsl:otherwise>
      </xsl:choose>

      <!-- Barcode -->
	  <!--
      <xsl:if test="string-length(@barcode)">
         <fo:block-container position="absolute" top="257px" left="2px">
            <fo:block>
               <fo:instream-foreign-object>
                  <barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
                     <barcode:intl2of5>
                        <barcode:height>14</barcode:height>
                        <barcode:module-width>0.027777778in</barcode:module-width>
                        <barcode:wide-factor>3</barcode:wide-factor>
                        <barcode:human-readable>
                           <barcode:placement>none</barcode:placement>
                        </barcode:human-readable>
                     </barcode:intl2of5>
                  </barcode:barcode>
               </fo:instream-foreign-object>
            </fo:block>
         </fo:block-container>
      </xsl:if>
	  -->
	  <!-- Barcode intl2of5 <xsl:value-of select="$fontColor"/> <xsl:attribute name="color"><xsl:value-of select="$barcode"/></xsl:attribute>-->

		<xsl:if test="@barcode != ''"> 
	
				 <fo:block-container position="absolute" left="0px" height="27px">
				   <xsl:attribute name="top"><xsl:value-of select="256"/>px</xsl:attribute>
				   <xsl:attribute name="width"><xsl:value-of select="$nanLength * 10 + 28" />px</xsl:attribute>
				   <xsl:attribute name="background-color">white</xsl:attribute>
				   <fo:block> </fo:block>
				 </fo:block-container>
				 
				 
				 <fo:block-container position="absolute" left="7px" font-size="30pt">
				 <xsl:attribute name="top"><xsl:value-of select="257"/>px</xsl:attribute>
				 <xsl:attribute name="color">black</xsl:attribute>
				 
						<!--
						<fo:instream-foreign-object>
								<j4lbarcode xmlns="http://java4less.com/j4lbarcode/fop" mode="inline" >
									<barcode1d>
										<type>INTERLEAVED25</type>
										<value><xsl:value-of select="/LISTE/BARCODE_NAN" /></value>
										<X>2</X>									
										<N>2</N>
										<margin>0</margin>
										<text>x</text>
										<barHeight>20</barHeight>
										<leftMargin>4</leftMargin>
										<topMargin>0</topMargin>
										<barColor>BLACK</barColor>
										<backColor><xsl:value-of select="/LISTE/BCKCOLOR" /></backColor>
									</barcode1d>
								</j4lbarcode>
						</fo:instream-foreign-object>
						-->
						<fo:block line-height="1.0em">
						<fo:instream-foreign-object>
							<barcode:barcode xmlns:barcode="http://barcode4j.krysalis.org/ns" message="{@barcode}">
								<barcode:intl2of5>
									<barcode:height>11</barcode:height>
									<barcode:module-width>0.013888889in</barcode:module-width>
									<barcode:quiet-zone enabled="false"></barcode:quiet-zone>
									<barcode:human-readable>
										<barcode:placement>none</barcode:placement>
									</barcode:human-readable>
									<barcode:wide-factor>3</barcode:wide-factor>
								</barcode:intl2of5>
							</barcode:barcode>
						</fo:instream-foreign-object>
						</fo:block>
				</fo:block-container>
		</xsl:if>
		
		<xsl:if test="@nan != ''"> 
				<fo:block-container position="absolute" left="7px" font-size="30pt">
				<xsl:attribute name="top"><xsl:value-of select="285"/>px</xsl:attribute>
						<fo:block font-size="17pt" line-height="0.9em">
						<xsl:value-of select="@nan" />
						</fo:block>
				</fo:block-container>
		</xsl:if>

		<!--
		<xsl:if test="@ean != ''"> 
				<fo:block-container position="absolute" left="7px" font-size="30pt">
				<xsl:attribute name="top"><xsl:value-of select="285"/>px</xsl:attribute>
						<fo:block font-size="17pt" line-height="0.9em">
						<xsl:value-of select="@ean"/>
						</fo:block>
				</fo:block-container> 	
		</xsl:if>
		-->
      
		<!-- Schnelldreherpunkt und R -->
		<fo:block-container position="absolute" top="264px" width="12px">
		    <xsl:attribute name="left"><xsl:value-of select="137 + $smartShoppen * 10"/>px</xsl:attribute>	
			<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
			<!--<fo:block line-height="2px" font-size="17pt" font-weight="normal">R</fo:block>-->
			<fo:block>
				<xsl:if test="@schnelldreher = 'true'">
				<fo:instream-foreign-object>
					<svg xmlns="http://www.w3.org/2000/svg" id="svg70" version="1.1" viewBox="0 0 12 12" height="12px" width="12px" xml:space="preserve">
						<circle cx="6" cy="6" fill="black" r="6" />
					</svg>
				</fo:instream-foreign-object>	
				</xsl:if>
			</fo:block>
			
			<fo:block line-height="1em" font-family="Frutiger 57Cn" font-size="17pt" font-weight="bold" color="black" >
				<xsl:if test="/LISTE/JSON_TAGs/@Raeumung &gt; 0">
					R
				</xsl:if>
			</fo:block>	
		</fo:block-container>
		
		
		<fo:block-container position="absolute" color="black">
				<xsl:attribute name="left"><xsl:value-of select="105"/>px</xsl:attribute>
				<xsl:attribute name="top"><xsl:value-of select="284" />px</xsl:attribute>
				<fo:block font-size="17pt" line-height="0.9em">
					<xsl:value-of select="@lagerLieferant"/>
				</fo:block>	
		</fo:block-container>
			

		<xsl:if test="$isNutriScore">
		<fo:block-container position="absolute" top="268px" left="148px" >
            <xsl:attribute name="left"><xsl:value-of select="148 + $smartShoppen * 18"/>px</xsl:attribute>		
			<xsl:choose>
			<xsl:when test="$isAktion">		
				<fo:block line-height="1em">
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABL0lEQVRYw+2ZwRKDIAxESYb//+X00NpRFN2NGkcgM71UIySsj0TEUrJUmq3/+ptIat2USghyvQGThVKYgCfFtJCkQv3qVkBLijFbxPNVypkAGcZM47Bc8vgxPvP4RZL2wAhqYc02QDsSkzKTwV5sKGXDMgxQkX211K6xoEP82PvJglTvfj/dxaCnREB9RJY/SCllUMxWON17pKy9bRMd08M84LnqVkBghRldYWdoJRm1lJM68otuMIH56S2TvIIpdyuxwhOuTkF3oTlTIoN+jClPSTyYe9n1wD21sJ8falspwjGWX2CNky8d0LNytQSz410I7AzD8WjlzkwqIgGET6Zk30lTOBrCkRSs5dAejixYLJz7Ros0fW+yn0A0guavSMYsHt+5T+OvnIxj07V9ABoWiFMJOzPyAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAABP0lEQVRYw+1ZyxICIQxrGf7/l+tBcZEBoYHycGXGGy0hpKGsLERCo4ZkUjHTaYOHkCINKQ4i55MUUfATNmkdM42J69DcGyQCVBuzIxkxthc+FomQaiTes0GklMJ6CMaWmGg/7mRDtC0f67I5qYyIyFswfRIBueFmyvKU4asyR00xjmOuK0bb+CGNYglDEueqCdBrVxNXmous3RrDfP3MPKXXdFNwrSqN52gIUXtKClTbtaYngJgtUraDOub1SllhxilpzZ4SJiLsVxbd4tpWeQpqsLn41QoY6ik7nOjst1VRKTEQ1Ci1gEIPk1ujRW3aUoU9JU3cWwY1Ukv5EYKHd7TfkvY8960UZlRWfgsPuN2D8Dak9Nbu5i9n94vy7y3/59d89G0yM25ip+u65LzoyjRt++n/Z5jh7VPb8GGfJB/TZJJBdAFfbgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABPUlEQVRYw+1ZSQ7DIAzEiP9/2T20VDSleAEvkco1sj3xMuMQwFKwRB1chAYIg1VTJoTz3PDAR6dYA+nVl8TR2Oxge3cKol9lpHE8cb1iAeIQVTLH3Uxjs1lJE4wDtpqB2FKcr/HJODaBxNuyVSlaeWIluSdjNrbBo9zIlhWSFPvlKL8A646ZPaN8MnFW0oG0lccAXNsuhyd4h+ujd+kkkc2EG6gqrxLnUQSioypL34OJz3v7PdspVzBZdx8CZ2WNgrY1M3eYiFO0BLuTSO8FUcUp1lvl6MdiT9m0byywEmk99RKUgu3wmIpTro61mV/ZWYzWIWJvRzZQLZhfGzMnYZqYTJv4D8KEClXL/wQmJVhRdEm5yyrvMMbP23yvhHBl9pSdEmN1/0aRxvLCNqz8EPaH0Ep2b60+nJu3oPMA1r+OSDWUAi8AAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABQElEQVRYw91ZQRLDIAgMjv//Mj10bBMbDaxgUWdyMiguy4IJ8XHwsdLgjrtEJlukbQCRzAsHXZjCAUlToq/xbcTmwxTmmICgwULOcsKAmE8raHKymElttO9bsBc5z0VTjERq2fGTPrukjZF9XjWansUh70R7K4DyI/0kWtNyBrVF9Y2oD4zQz/S4gBZ9TeRa85I9Swmt35UCSvR9XDvasoGWIR0HXQT1YZ8k6ik8G7vawRFwQgotSuV/l3qxptSpIGWLQzVwY2iDldlMYEeAjNDvwELrcch6TeRyapymuVsRtGBor+ojrBzpcCFNuasIHrfUu3lp9XFs+bP4EOjcDOojRWCbu88k4V7rG+2kERuU0dQC7dMSjdbk1Hx/zY/eeaKNJGiXQt9R0DRAznNqBWipP4SSyBsEeK3qgzSDwHgBRmeMSnZLe9oAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAABJ0lEQVRYw+1Zyw6EIAxkCP//y90TG0RFprRqQBIPri22w/TlQkKQMPuShovA7qe4NCAnz7FhikxCmnz6jD8FY+JfWWQthjTkIVLegd+kV4eVH9EbOWCgyCmssRPnoDijU6MrftTYr7SEl1epoWJXuhTuyTVnlNXqnukxsi7hkw1gY7Q0UtE40e9k24ksX16u4ZMBAThAGCA18iZMqXsDz8aupj/AhYSDjbZMqQ17Y+/TwbLYFQrMSThT+5mSrE2wI0A+NOPYNG8eTtZ7aodTw1BNZhVBM6prWemcu1J3RfA4vaN9WQct5JsdbesF2meWTt1UzdaYfUiWf1PyEqCMhtjmy5vIR5GMi4Qg0wEyWC3ja2eUu8OokMf0/xCynyKWAOUKnANG/QA4g5QhzaonIgAAAABJRU5ErkJggg==
		"/>
					</xsl:if>
				</fo:block>				
			</xsl:when>
			<xsl:otherwise>
				<fo:block line-height="1em">					
					<xsl:if test="@nutriScore = 'A'">
						<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAFYElEQVRYw92Y7VMbRxLGfz27KwnzDkaAKeJzjHEcX3IOhiqTXN3/nkrifOHucqncpXyc8fkqCVgECQR62bfpfEASu5ZWWijb5zBVWytN9TMz+8zTPT0tqqoAqoqq8vw/z1m/v05WazabFItFjDFc1ybWWhWRi47O7/HSGMViEU+EIAhotQPaNmR6coqdnR3W1u9dY1LiWKWz6yLCrfIipVIJOe8AQAEB4jiiVjvmpHGGqvJq/4DNjQ1m5mcRMQimYw1dHVnAIHz3w/cDF/Doj59gE/9fx5XGxs4nB1qtFqpgOnN07ejYWixqoVAs4Hkexhh8PyAMgwHjC9931hS0fbxi4YKUKIrUcRxcEVZureB53lAW4zimXq9TrZ+gqiRV9ntv3RDiOo6DiLC6fAvXdUcCHcdhZmYGv91GROiEpHyy7CrvEpir4i6D6dqKCGEYYkQETySlEFXF933q9TrHx8c0Gw3CMEwNMjc3917v+ubW1qUU0m2e5+ECjI+Pp9wgCAKOazXO/Havr+h6rCzfQsy5nVcovO++cGnX6XJgAFwn7Tb1ep0zv93zMVXFj0Kagd8nuevYOsfORYe1lnqzMdC4flL7XQTLN0NKovnt9sDBVZVm28damxmsko/Teedp5bn5PvyowJh81u7e7VOwiYdjus/c9OxoUo5PToYuqNVq5dqtmZnZXG4mIhzWqheBTs6XtL39ee6dfb63h4iw9Wgj+8MGHL2qSnWA+lPYOIppBj67Pz7LjB21arWX0A2T71HiQ0cdhaednEdVCWxMwXH59tunufMKVWV7+3N2/vH3N+JeKVIazQaz09OsfXR+99nd3U0dvUEY4tuYKIowNt8u/uWLP4+0mZicSrtwFF46Djx9+g0ApWKpy/iVY4qbZPCoVk2l3Ovr670dVVU812V5cYnTszPmpmYGJ3fiYBOjfPn1V289MKYITZyQw9Q5bH7T9YUwDLE5Frn/6oDqyXFmHmCxqTHyxJS3TdTr7dm/n/XcbqhSmo0mG58+Grm4bpKTzHAHYbrvLFKqR78CsLbWf9v2fZ9SqXSlq8D2kycMC3p5Cdeb0zPaGUbztIcfPdC5qemUfRZ+mE0WZmGh3DfGKNz42I1U3+bjx7nmen2eP33yqRqAwPf7WGy3W4mELn3o//Djv6jWT4bmEMvlxZGuk1RT8jk8rLD52UYudZTnFxARGq1mLhU82djMlRP1sXhaP9Nkf5YCBu2EJ0aLYnTtD3f7cIPG2v9lPzXPzdcUmDWX57hacD29v3ZPAQ3bQa71FXFS893+YLVPKW43y9/be9FjaXJqAlcMK6uruCKcnp7y8N59/rn77I2dIt3YtLS8dCVsnovdVdZnjEEALYghVNuLTR7C/Pw84xMTAERRRKVSoZWoYJUcl3YcXYt6Sl9dBdDJ0hgL5TLGGKw9P1KzCtNdYBiGvPz5J/yWT6FUeO9I2draYmdnZyQmqaxU6eC03cIYOb/siWQSoihWLVYtfic45yXk3VefL6mOzvvlf18iL/Ze6J0P77B0c4GJsRtYI5njKWDseXnh5c//I34Hkn7b7mPjCMf1UqUT94PbtwE4+PWQ1YUlCjdK2ZUsAbVKtXqEK4bIxjz4+AG12jEigrHZGzQ2foPy/AKVo0M2P3vMX7/7W5/NyuJy34ctLS32/n94+04vfch0B4HZ2YtywMcPHlKr1Th4tZ/7gilWVSXB7PzUNBOTk31FbFUlCEMqlQpBHFE5eIUiLC6Vr0UVP7UZmuhJHmUGKHoeIkIURgRq39nd5P9CTCIM9UhRwFql1WgwOTWZCY7iOFd1bOCslwyCfVi55NflwWl/leE3L9v2ELtK6joAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'B'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAC4jAAAuIwF4pT92AAAEZ0lEQVRYw9WZ+1MiRxDHPzO77C6KcEIMeI+Yxw/eKxVjvP//H9BU6ire23vkLuoRPFAQ9jmTHxQEWRZ2OS1vqK1ii+6enm93f6dnEFprzRxDa00URZimiRAi9vdvbch5Dey9ecv99fUBIOKSUSFELFg3eYjhTEnjfF9NCEHBzlOplDHN3BkqQzKu69JoNPBVRKt1jCkEhVJxxNbG419RMZFSgETg5PMDu71eD61BcpGBaqAnUCi0Asu2yOVySCnxPJ8g8GPsC57+/RQA3/XI2dYFKFkiqbVGCEG1XGGxUJgIqNYarRSNoyNCpei6PZycjRf6NzJLtNYIuIA8Tf3nnTx526a8vDyTfBhFfNrfJ1JRJp7pg55GN43OcFBlVkJ0PZdyqUQURURRRBiGBEFAEASEYUgYhiM2TUNSXa5ca9S3njxJTQcAJsDavR9SR00CAkm328ZzXU67p4QxsrcKS5RKJQzTZCHvDPSvZVfKOIcE+PDxn9SKOcMEoN1uc9w9JdD6jD8uPbVajf3DQ6IgRAjJtzAye9mvwV6QTJjPX79i7e5dOp0O19WxzJuFclbymXU8290d03v9/h3tk+OpIF9+ssr3v8touk7cPHIaIGmBefT48ZjeyxfP8RPyZNIcaee+vEg5JZv6z8yg2JbFcrH0VdJ5/f4DcghEwsLbJ8djjs5SBkmLy1peZlKEXM8boD/rpJflfN/Htm0K+YVEvcJScW5e6DeUA38zHi/MqyY9wzAA6PS6KBVdCTFm3SQmzS+nRXz4jJNlUsMw0FpTLt3Cdb2ZueOqgXr56uXEsjNnIVgLkUiUk/SHJ/xy3GJl6daI7JejxkQ7nufhOM5cGTDJ5UycAvBw/QH1eh3bsXEch713b1Nxi2VZMV6PvpYr300+W+XzmbOlrxdKNT+nDCO9++JZ8tao0kXBNiwc20kkx7jITwNmGj98FU7Z/G0Dr+cOCY/WnXv+W5peWAiBH/nx2QMc7B98FQIO3NHuentnZ/5MGXVCn300yJiICXVWDYu2w6nn0vrSonXSBHUGQrPV5PfNTe7dvoMAbldrSCljs6S2WksNQJJ8325WkMc4RaPP2yyBTNhxQhRKQrFU5LTuslwZv1exhMTtdlm7cxdpmqD03MeITIQ7b58S33fGpKqKQGsW8gv8svbjKN0oNZ4VQBQprnNsbW2xvb09c9M31ym5zwFBGMafMqWM3Xg6nQ4LtnN9zZrIllmZryOFEBTyC1RXVlDnl05Jww9DPv77KXNjdpXXkSoKMczcRfkMp06aWvz8uU61+j3OyQnFYjHxnBGGIf/V66zWVtk/2EcIwR8bm+z89eeY7J3q6tjCarXq4P3ntZ/wPS+5HAQsD90dP3zwiGazyeHng9lKSWutFWCkJKfh9t+SBisrK9i2PQB278P7EflqucLhUYNu+5TFYuHG3bYNZ5OY9x/CyA8wbevKb8OuBZhzPokFJa37SmlMYzKrqH5WZbA95pRIsbpZ9S7dMvwPPVhJgq+dujcAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'C'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAE10lEQVRYw8WZ23PaRhTGf7u6AEkAAwZ8iS9J2ukknSaZjvOUTKb/eqd9q/OSaTt12zjGaRIjbnFNMAhptw+YmxFECEPF8CDY1dn9zne+c85KaK01S7i01gghAu+VUgAYhjF1vud5CCGQUrLqa2kWRwG5fi+lxDAM0qlU4NxkOoVpmv8LIADmrI0sgz1oKOZyAFhCsrd9F8Mwera1xvd9ms0mF0Axm+OsVkEIOVjbk+8eozVIhgRXAw8LFAqtwI7ZWJaFlJJOx6XbdSeYoBC8/vU1AG67gxWzezhorfWywRgFJZVM0W23KRaLmKY5dZzv+ziVCoZpcvG5ySrXKGAI+Tzy8vWDr/j7+M1cc4QQSCHZ3d6eqScDXfF93r1/j9KKKNLXBzLM3LHwjgIIwHHpbSRPFPP5cUC0Rl99fd8fiDCAaRjkc/nIXj949my+0B7VlL2d3bkNKl9F8tqteHyQgVqtFo1GA1f5Y2NvWTZrmQyJRJxkPE75av7cbImYWCVA6d3p6qRdCDzPw3EcyrUqrvL53GwN2OKclWl1XT44Zer1cxCs/DJXbVArRa1a5XOnHej5fLEwqGkaF59I2NbCNdKNghKWstcXIK/SZNDcVqtFcwogQRv7UKuEsjmqC/3/pP/lOUF6Kr+00XkR11qztpaZOrfRaATaEkKQy64vXDAGZpEp6+x/Q1e0Mdsmk0rPX5wBtUZ96piO8rlstyfAX0umaJ5/4uXzF/zw/MXg9+31whdtTttcmEwTOnz6C2p3OgP0o9QJL5+/CPw9HotNeCaXzZJOJvnr6AghJTubW72KVAiozqclg/VG1JUbFVpDGCiGqfrHn38KNS9m9spr07IwraGw6tEafol9WWhN6Q+8Ll4zaxfGK8+weuR53lgBp7Wm2+1yXDpZWhY8+vNoatiZYQTWRuCiQ8fqPEACdFH4ntfrd5wK+/t7HJ+WKGRzcxVgE/b0DWoKwKNvHuI4DrF4jHg8zpu3x2PaYgD+AvQdBVAIQenD+6EXj98ghMCp19De/Fb6z/akWlxTRpH+7Y/fZ4aBGO8lx8Zt5AucVZxAg7lUmnQmM7GJy8tLbNse9EV9sDzfW0gfbkRTvn/ylM5le2TweNy1+/8FcNMSkpiQ3LmdnLrAO8kkJ6WTiYUlEomJzvnpk8egw2eQbtsduz989WpxpoxvQvc+GmRASlZzeme0893a2OSfs4+9ECk75Av5CU/m8+ucn5+zlSvQaF3MpQvTyvyw65xgypABvbMPKYIT1CIHu7FYjN3NLVKJWxSKBYQQ7GxsspFbH57jdrpsFTawTCuSZt1oQyhW1JZatk2+UCCnFL7v4/s+pmWNHU9qQKvo8B8cHHB4eDh3A7myLrlv2HVd7JGKVkqJlBLLsgLEHNyOG+kQbPCACMySUSn3YP9+JHCcanXsdG1mUacU5Wo1siMOfzkMNU753jhTRqkTJRbDzknevjNgS71eJ5vNznyFoZSiXq/RUd1e551Kc37xL/d293E7ndmsFJAZSfuPHn5Lo9HgrPwxHKO11loBxgpOy7XWlN6esH//HgZQyBdIxOMIKQZc10px2W5TqTh4wOnpO3Z27q7m9Uvf0ct6Q3gTDFv10vSVawJB0SswrxUYxvTw8ZWKzg49IrI6hOheO2X4D0EEekV0JSnJAAAAAElFTkSuQmCC
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'D'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAEW0lEQVRYw81ZW1PbRhT+VpIlYdnyDUKmmLgTIA20tJ0+xZD2v3faX5DQaQwlbS4EMLINGGNLsnb7YORI8srW+sL4eDQe6+zZc/bbc9s1YYwxLIAYYyCEzHU+6lEoKSV2jOd5AABJkmbSJWFBNE9AAODuro3qq+pY42VZBqNzsD3oKfNeyLw8xLfNUDUUi0WkVDVkK2MMju2g0bDQ7bshmYNXVdi2A9d1RsCkIHhz9AYA4PRspDT1KyiPAUY2baB934Hsu3pCudubW5g5E6v5AkzTHLtxlFJcX1+j1b4FYwz7P+zj6K8j4U1QoognpZ2tbfzz/jSxjK+nL5jCKpVnyKWNiYD4uaSQL8B2XRxWD/D26K1wuBNCQAAwUUAAQFZkUI8KgyKi5+zjZ5Qrm6hslKEoStKthuu6+Hj+RXhNvo0KAFQ2nwmHA/XowkOuXNkEALiuC8uy0LF73EphZk1kDWOYa1Kp1HCR0xTXqT1FdOen8RRfJpc2cHPf4coGQ8pQNRRLJaiqitMP/02tT8KSkwSgfd8Zmxj9p+PY+HT+BX3XXVyfkrQqEUJCj/zwPTFnnH3Gj3vfj8iHwvThESnfVrOZyE4yxk42mC9M/nseL8jnjS3mCyOy0d+1v2shueDzuno4Mm/Ujrj3HqXCMhw+f5Cmqqxg5oRAiePzfpvZHFcukza4YPPmXy+UuLyXOy8S2RS3JmVc2PRse+hi02Tx3w5fxzdl7RtuImx37hLPnzGzILKEC+sq9P7dyfFMOUWZZ1KUiQwayAC///kHd9xx7WRuOld0feZzWXRjpElJK3iOmNi7INzMxclkMulYoygV63+cKStN7bg2rFoTPSXY7vqkgsABS5z9JwH5zcYGAKCQMUfGiRz7+/0+6peX+PXgcKpDZuLmzTdw77td1Ot1aLoGXddx+u/70IQKIfAi9yZRZcFcFB0Td+YihGC1UMJV0xrr5j6vmM2jcduKDQ+eTBwoIbm40jqulCkgsVXi6dqTidWHJxfVE1d9LMtiANhJ7ZhbQQxVE9IX5Y/46i8//Qy72wsgGo67ns/jhFOKSNCIhIyRTeSmQf7+7l6oQw26cpRKpRIYY9h+scPd6WKpNL/qE14EG3wYIHFKMhWI0VnimwHQlRR6fXdsNSnk8pBB8HR9HaqqTqUrtvp89QACiUiQiBRr7GNRNjvwPCmmTZcByIRgs1yGrmnAjNfOo9UHy3clmclkYBhGKLT8UJFleSSxi94kRmUULDH5xrqOAy1hk0YA3Hc6U11rjISPKLpb3z5/NHAuLQtewgVSxlBvNAQvzPphTwm6zjQX2KIyIuO3n28NveW61UIhnx/b3Hmeh2azCY8NOusVTUfPsbH7cg+tVgsXl+fJvJMxxuhDolrWEPLBTBEJa6ur0Ff0ELiUMnS7XdStK8ggOLu4wNr6E6ENCLUBi/qHcBGUZJEztQcPOYkLyrKi5FGKVKDajIYPHQBHOIsh49EI4v0/E0feEk8PfDsAAAAASUVORK5CYII=
		"/>
					</xsl:if>
					<xsl:if test="@nutriScore = 'E'">
					<fo:external-graphic content-height="28" src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAEUAAAAcCAYAAAA3DHIWAAAACXBIWXMAAAsTAAALEwEAmpwYAAAD7UlEQVRYw+VZWW/bRhD+ZkmR1OErkmXJinwlQREHaYsCzUOv/140RX9AgbZOjySWj8a2JFuyTYk0d/og06ZEilxaUeMoIyxAijOcnW/n2iUxM2MKxMwgInwo8s2SUkLX9bF8ruNCaAJEBCICM0DTAuW+0OjCCAByhKfX68M0jQGIzNDjXvCxkr/ORARLy6BUKsIwzSEbmRmO46DZbMKyTAR9Q/iM0wZkLpcHAGjXQ4UWzNzNtQa1+W1tbN4YvzQ3j+pqFaZlhWwkIpimiWq1iuL8AogIrVYLDIAA8CjCKvTk0WP89c/fyjLBFUpDG2vreNvYTSVHRMhlDKxUKhBCKHnW4bsjVGpV7Ozs3IKSdrKarkF6cuqg3EWOiFCvrsIwDNV4g+tJ7O43AGCQU9bra6nDQXryXidWwzDgOA4ahwep3yEA4G1jdyYrj23bd5ITmFEiAL1rUJg5dgDA1tq6GiiqFcnP7P7QFKvZ/v4ePt9+FpJX1ROrQwKe56l7RyAhiyRA0pZqZsbi4lKi7Ks/XuHhwzp+/f230LPvv/kuVQ4Zp8e+cpWAXcgXIOVtjhzb/5qGgZyVRbtzlrpparZbiWB+/eIFolqBuXwBL3/5WUnPpA2nqWdQLJWQvW7sYj2FiNB3HLTOTidS/MO341e80z2LLLXdi/NU5TfYvaal/pWLg38PQ//r7zO5aaRBBnYWP778KTp0dv784FuAOCBFknCalZCQSkoLhdzYiQZjexp0fHw8dL98nf9iPSUqwRogOGDlVUgCcrVWAwAsFeZDfCpt+SSb2HK5fHOdzZgwLUvdU7Y/e4rSUhG16irqm5uhCWjvYdXa552QUUSE5QelicLixmg9E9/cuX00T07Q7XRC8jx4J7N/7d/7FPW/DoqUA8CV5XKIP+m9oyNKLok3yPO4vsFZPZNKpz9CnvLVF1+ib/cC6PMQij3/WUQ4ZUjAJIFCfk5pExd8/vzp9lD3qUpuz4lvayN0JnW0+ngX5MGPAUEUmqhMcN1J3P4uvFHHn5aRhe26ahvcuOaNwSAQAIKISWL37QxzFBApACtvIef0YAgNLkdXtYKVRd60hhJ8uPpgNo4kwYyslYVVsSDlSKsQtFeIEKD6fbdNIwGPZaoQIyLYl5fI5fMgotgy7x8/+scMBweHtyU5bb1/tLH1v4BSq9fu1qSdHKvvkj2Jo6MjAMDKSnnwiWNWTvGD3mJpOgzDQLFUgqZpY0NMMuP0pIW2fQ7vygWENvAUbwY//bRPT2H3bOzuNXBxcRHaPrCUuLRtNPb20LbP8fr1GwhNhyD69D6GqZR6/WMot5OQJyW6nS4WFxfG9ic8UpH+AyIEUNi4yywFAAAAAElFTkSuQmCC				
		"/>
					</xsl:if>
					</fo:block>	
			</xsl:otherwise>
			</xsl:choose>
		</fo:block-container>
		</xsl:if>


	  <xsl:variable name="preis" select="format-number(@preis, '##0.00')" />
	  <xsl:choose>
	  <xsl:when test="$smartShoppen">
			<!-- Preis mit Smartshoppen -->
			<fo:block-container font-family="REWE Preisschrift" position="absolute" right="3px" font-size="98px">
				<!--<xsl:attribute name="font-size"><xsl:value-of select="480 div (string-length($preis) - 1)" />px</xsl:attribute>
				<xsl:attribute name="top"><xsl:value-of select="300 - 660 div (string-length($preis) - 1)" />px</xsl:attribute>-->
				<xsl:attribute name="top"><xsl:value-of select="194 - $isFW *35"/>px</xsl:attribute>
		 
				<fo:block bottom="3px" position="relative" text-align="right">
				<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>    
				<!--
				<fo:inline font-weight="normal" font-family="Arial">
				<xsl:attribute name="font-size"><xsl:value-of select="48"/>pt</xsl:attribute>
				€
				</fo:inline>
				-->
				<xsl:value-of select="substring-before($preis, '.')" />
				<!-- Create an inline object for the dot that only progresses 2px. -->
				<!-- inline-progression-dimension seems only to work on inline-container, not inline -->
				<fo:inline-container inline-progression-dimension="2px" text-align="left">
				<fo:block-container>
                  <fo:block>
				  <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
                     <fo:inline>.</fo:inline>
                  </fo:block>
				</fo:block-container>
				</fo:inline-container>
				<xsl:value-of select="translate(substring-after($preis, '.'), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
				</fo:block>
			</fo:block-container>
	  </xsl:when>
	  <xsl:otherwise>
			 <!-- Preis ohne Smartshoppen -->
			<fo:block-container font-family="REWE Preisschrift" position="absolute" right="3px" font-size="160px">
				<xsl:attribute name="top"><xsl:value-of select="132 - $isFW *35"/>px</xsl:attribute>
		 
				<fo:block bottom="3px" position="relative" text-align="right">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<!--
					<fo:inline font-weight="normal" font-family="Arial" font-size="60pt">
						€
					</fo:inline>
					 -->
					<xsl:value-of select="substring-before($preis, '.')" />
					<!-- Create an inline object for the dot that only progresses 2px. -->
					<!-- inline-progression-dimension seems only to work on inline-container, not inline -->
					<fo:inline-container inline-progression-dimension="2px" text-align="left">
						<fo:block-container>
							  <fo:block>
							  <xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
								 <fo:inline>.</fo:inline>
							  </fo:block>
						</fo:block-container>
					</fo:inline-container>
					<xsl:value-of select="translate(substring-after($preis, '.'), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
				</fo:block>
			</fo:block-container>
	  </xsl:otherwise>
	  </xsl:choose>
	  
	  	<!-- DKK Preis -->
		<xsl:if test="$isFW">
			<xsl:variable name="fwpreis" select="format-number(/LISTE/JSON_TAGs/@FW_Preis, '##0.00')" />
			<xsl:variable name="fwpreiseuro" select="substring-before($fwpreis, '.')" />
			<xsl:variable name="fwpreiscent" select="translate(substring(substring-after($fwpreis, '.'), 1, 2), '0123456789', '=!&quot;&#167;$%&amp;/()')" />
			<!-- Euro-Betrag mit Punkt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="257"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="22"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>		
				<fo:block font-family="REWE Preisschrift" >
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size"><xsl:value-of select="42"/>pt</xsl:attribute>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="22"/>pt</xsl:attribute><xsl:value-of select="/LISTE/JSON_TAGs/@FW_Waehrung"/></fo:inline>
					<fo:inline font-weight="bold" font-family="Frutiger 57Cn"><xsl:attribute name="font-size"><xsl:value-of select="46"/>pt</xsl:attribute></fo:inline>
					<fo:inline><xsl:value-of select="$fwpreiseuro" />.</fo:inline>
				</fo:block>
			</fo:block-container>
			<!-- Cent-Betrag, höhergestellt -->
			<fo:block-container position="absolute" text-align="right">
				<xsl:attribute name="top"><xsl:value-of select="257"/>px</xsl:attribute>
				<xsl:attribute name="right"><xsl:value-of select="2"/>px</xsl:attribute>
				<xsl:if test="$isAktion and not($isPage2)">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
				</xsl:if>
				<fo:block font-family="REWE Preisschrift">
					<xsl:attribute name="color"><xsl:value-of select="$fontColor" /></xsl:attribute>
					<xsl:attribute name="font-size" ><xsl:value-of select="42"/>pt</xsl:attribute>
					<xsl:value-of select="$fwpreiscent" />
				</fo:block>
			</fo:block-container>
		</xsl:if>
   </xsl:template>
   
  
   
   
  
   
</xsl:stylesheet>


