<!--Revision date 3 January 2004-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xpath-default-namespace="urn:isbn:1-931666-22-9"
    
  >
	<!-- This stylesheet formats the dsc portion of a finding aid.-->
	<!--It formats components that have 2 container elements of any type.-->
	<!--It assumes that c01 and optionally <c02> is a high-level description
	such as a series, subgroup or subcollection and does not have container
	elements associated with it. However, it does accommodate situations
	where there a <c01> that is a file is occasionally interspersed. However,
	if <c01> is always a file, use dsc11.xsl instead. -->
	<!--The position and content of column headings are determined
	by the presence of <thead> elements encoded in the finding aid.-->
	<!--The content of any and all container elements is always displayed.-->
	
<!-- .................Section 1.................. -->
<!--This section of the stylesheet formats dsc, its head, and
any introductory paragraphs.-->

	<xsl:template match="archdesc/dsc">
		<xsl:apply-templates/>
	</xsl:template>
	

	<!--Formats dsc/head and makes it a link target.-->
	<xsl:template match="dsc/head">
		<h3>
			<a name="{generate-id()}">
				<xsl:apply-templates/>
			</a>
		</h3>
	</xsl:template>
	
	<xsl:template match="dsc/p | dsc/note/p">
		<p style="margin-left:25pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>
  
  <xsl:template match="accessrestrict">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="scopecontent/head | bioghist/head | arrangement/head |
			userestrict/head | accessrestrict/head | processinfo/head |
			acqinfo/head | custodhist/head | note/head">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>

	<!-- ................Section 2 ...........................-->
	<!--This section of the stylesheet contains two named-templates
	that are used generically throughout the stylesheet.-->


	<!--This template formats the unitid, origination, unittitle,
	unitdate, and physdesc elements of components at all levels.  They appear on
	a separate line from other did elements. It is generic to all
	component levels.-->
	
	<xsl:template name="component-did">
		<!--Inserts unitid and a space if it exists in the markup.-->
		<xsl:if test="unitid">
			<xsl:apply-templates select="unitid"/>
			<xsl:text>&#x20;</xsl:text>
		</xsl:if>

		<!--Inserts origination and a space if it exists in the markup.-->
		<xsl:if test="origination">
			<xsl:apply-templates select="origination"/>
			<xsl:text>&#x20;</xsl:text>
		</xsl:if>

		<!--This choose statement selects between cases where unitdate is a child of
		unittitle and where it is a separate child of did.-->
		<xsl:choose>
			<!--This code processes the elements when unitdate is a child
			of unittitle.-->
			<xsl:when test="unittitle/unitdate">
				<xsl:apply-templates select="unittitle/text()| unittitle/*[not(self::unitdate)]"/>
				<xsl:text>&#x20;</xsl:text>
				<xsl:for-each select="unittitle/unitdate">
					<xsl:apply-templates/>
					<xsl:text>&#x20;</xsl:text>
				</xsl:for-each>
			</xsl:when>

			<!--This code process the elements when unitdate is not a
					child of untititle-->
			<xsl:otherwise>
				<xsl:apply-templates select="unittitle"/>
				<xsl:text>&#x20;</xsl:text>
				<xsl:for-each select="unitdate">
					<xsl:apply-templates/>
					<xsl:text>&#x20;</xsl:text>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="physdesc"/>
	</xsl:template>
	
	<!--This template formats the appearance of <thead> elements
	where ever they occur in <dsc>.-->

	<xsl:template match="thead">
		<xsl:for-each select="row">
			<tr>
				<xsl:for-each select="entry">
					<td>
						<b>
							<xsl:apply-templates/>
						</b>
					</td>
				</xsl:for-each>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<!-- ...............Section 3.............................. -->
	<!--This section of the stylesheet creates an HTML table for each c01.
	The templates for other components are in section 4.-->

	<xsl:template match="c01">
		<table width="100%">
			<tr>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="8%"> </td>
				<td width="12%"> </td>
			</tr>
			<xsl:choose>
				<xsl:when test="did/container">
					<xsl:call-template name="c01-container"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</table>
	</xsl:template>
	<!-- ...............Section 4.............................. -->
	<!--This section of the stylesheet contains separate templates for
each component level.  The contents of each is identical except for the
spacing that is inserted to create the proper column display in HTML
for each level.-->


	<!--Processes c01 which is assumed to be a series
	description without associated components.-->
	<xsl:template match="c01/did">
		<tr>
			<td colspan="12">
				<b>
					<a>
						<xsl:attribute name="name">
							<xsl:text>series</xsl:text>
							<xsl:number from="dsc" count="c01 "/>
						</xsl:attribute>
						<xsl:call-template name="component-did"/>
					</a>
				</b>
			</td>
		</tr>
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td colspan="10" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>	

	<xsl:template match="c02/scopecontent | c02/bioghist | c02/arrangement |
			c02/userestrict | c02/accessrestrict | c02/processinfo |
			c02/acqinfo | c02/custodhist | c02/controlaccess/controlaccess |
			c02/odd | c02/note | c02/descgrp/*">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="9">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="9">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c03">
		<xsl:apply-templates/>
	</xsl:template>
		
	<xsl:template match="c03/did">
		<tr>
			<td valign="top">
				<xsl:apply-templates select="container"/>
			</td>
			<td> </td>
			<td valign="top" colspan="10">
				<xsl:call-template name="component-did"/>
			</td>
		</tr>
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="8" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c03/scopecontent | c03/bioghist | c03/arrangement |
			c03/userestrict | c03/accessrestrict | c03/processinfo |
			c03/acqinfo | c03/custodhist | c03/controlaccess/controlaccess |
			c03/odd | c03/note | c03/descgrp/*">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="8">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="8">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>


	<!--This template processes c04 level components.-->
	<xsl:template match="c04">
		<xsl:apply-templates/>
	</xsl:template>
		
	<xsl:template match="c04/did">
		<tr>
			<td valign="top">
				<xsl:apply-templates select="container"/>
			</td>
			<td> </td>
			<td> </td>
			<td valign="top" colspan="9">
				<xsl:call-template name="component-did"/>
			</td>
		</tr>
			
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="7" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c04/scopecontent | c04/bioghist | c04/arrangement |
			c04/descgrp/* | c04/userestrict | c04/accessrestrict | c04/processinfo |
			c04/acqinfo | c04/custodhist | c04/controlaccess/controlaccess |
			c04/odd | c04/note">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="7">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="7">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c05">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="c05/did">
		<tr>
			<td valign="top">
				<xsl:apply-templates select="container"/>
			</td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td valign="top" colspan="8">
				<xsl:call-template name="component-did"/>
			</td>
		</tr>
			
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="6" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c05/scopecontent | c05/bioghist | c05/arrangement |
			c05/descgrp/* | c05/userestrict | c05/accessrestrict | c05/processinfo |
			c05/acqinfo | c05/custodhist | c05/controlaccess/controlaccess |
			c05/odd | c05/note">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="6">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="6">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>


	<!--This template processes c06 components.-->
	<xsl:template match="c06">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="c06/did">
		<tr>
			<td valign="top">
				<xsl:apply-templates select="container"/>
			</td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td valign="top" colspan="7">
				<xsl:call-template name="component-did"/>
			</td>
		</tr>
			
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="5" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c06/scopecontent | c06/bioghist | c06/arrangement |
			c06/userestrict | c06/accessrestrict | c06/processinfo |
			c06/acqinfo | c06/custodhist | c06/controlaccess/controlaccess |
			c06/odd | c06/note | c06/descgrp/*">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="5">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="5">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c07">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="c07/did">
		<tr>
			<td valign="top">
				<xsl:apply-templates select="container"/>
			</td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td valign="top" colspan="6">
				<xsl:call-template name="component-did"/>
			</td>
		</tr>
			
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="4" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c07/scopecontent | c07/bioghist | c07/arrangement |
			c07/descgrp/* | c07/userestrict | c07/accessrestrict | c07/processinfo |
			c07/acqinfo | c07/custodhist | c07/controlaccess/controlaccess |
			c07/odd | c07/note">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="4">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="4">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c08">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="c08/did">
		<tr>
			<td valign="top">
				<xsl:value-of select="container"/>
			</td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td> </td>
			<td valign="top" colspan="5">
				<xsl:call-template name="component-did"/>
			</td>
		</tr>
		
		<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="3" valign="top">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="c08/scopecontent | c08/bioghist | c08/arrangement |
			c08/descgrp/* | c08/userestrict | c08/accessrestrict | c08/processinfo |
			c08/acqinfo | c08/custodhist | c08/controlaccess/controlaccess |
			c08/odd | c08/note">
		<xsl:for-each select="head">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="3">
					<b>
						<xsl:apply-templates/>
					</b>
				</td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="*[not(self::head)]">
			<tr>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td> </td>
				<td colspan="3">
					<xsl:apply-templates/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
  
  <!-- from eadcbs5.xsl -->
  <!-- The following general templates format the display of various RENDER
	 attributes.-->
	<xsl:template match="emph[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	<xsl:template match="emph[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>
	<xsl:template match="emph[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="emph[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>
	
	<xsl:template match="emph[@render='quoted']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	
	<xsl:template match="emph[@render='doublequote']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	<xsl:template match="emph[@render='singlequote']">
		<xsl:text>'</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>'</xsl:text>
	</xsl:template>
	<xsl:template match="emph[@render='bolddoublequote']">
		<b>
			<xsl:text>"</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>"</xsl:text>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='boldsinglequote']">
		<b>
			<xsl:text>'</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>'</xsl:text>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='boldunderline']">
		<b>
			<u>
				<xsl:apply-templates/>
			</u>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>
	<xsl:template match="emph[@render='boldsmcaps']">
		<font style="font-variant: small-caps">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
	</xsl:template>
	<xsl:template match="emph[@render='smcaps']">
		<font style="font-variant: small-caps">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="title[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>
	<xsl:template match="title[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>
	<xsl:template match="title[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>
	<xsl:template match="title[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>

	<xsl:template match="title[@render='quoted']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="title[@render='doublequote']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	
	<xsl:template match="title[@render='singlequote']">
		<xsl:text>'</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>'</xsl:text>
	</xsl:template>
	<xsl:template match="title[@render='bolddoublequote']">
		<b>
			<xsl:text>"</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>"</xsl:text>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='boldsinglequote']">
		<b>
			<xsl:text>'</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>'</xsl:text>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='boldunderline']">
		<b>
			<u>
				<xsl:apply-templates/>
			</u>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>
	<xsl:template match="title[@render='boldsmcaps']">
		<font style="font-variant: small-caps">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
	</xsl:template>
	<xsl:template match="title[@render='smcaps']">
		<font style="font-variant: small-caps">
			<xsl:apply-templates/>
		</font>
	</xsl:template>
	<!-- This template converts a Ref element into an HTML anchor.-->
	<xsl:template match="ref">
		<a href="#{@target}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<!--This template rule formats a list element anywhere
	except in arrangement.-->
	<xsl:template match="list[parent::*[not(self::arrangement)]]/head">
		<div style="margin-left: 25pt">
			<b>
				<xsl:apply-templates/>
			</b>
		</div>
	</xsl:template>
		
	<xsl:template match="list[parent::*[not(self::arrangement)]]/item">
			<div style="margin-left: 40pt">
				<xsl:apply-templates/>
			</div>
	</xsl:template>
	
	<!--Formats a simple table. The width of each column is defined by the colwidth attribute in a colspec element.-->
	<xsl:template match="table">
		<table width="75%" style="margin-left: 25pt">
			<tr>
				<td colspan="3">
					<h4>
						<xsl:apply-templates select="head"/>
					</h4>
				</td>
			</tr>
			<xsl:for-each select="tgroup">
				<tr>
					<xsl:for-each select="colspec">
						<td width="{@colwidth}"></td>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="thead">
					<xsl:for-each select="row">
						<tr>
							<xsl:for-each select="entry">
								<td valign="top">
									<b>
										<xsl:apply-templates/>
									</b>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>

				<xsl:for-each select="tbody">
					<xsl:for-each select="row">
						<tr>
							<xsl:for-each select="entry">
								<td valign="top">
									<xsl:apply-templates/>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>
	<!--This template rule formats a chronlist element.-->
	<xsl:template match="chronlist">
		<table width="100%" style="margin-left:25pt">
			<tr>
				<td width="5%"> </td>
				<td width="15%"> </td>
				<td width="80%"> </td>
			</tr>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	
	<xsl:template match="chronlist/head">
		<tr>
			<td colspan="3">
				<h4>
					<xsl:apply-templates/>
				</h4>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="chronlist/listhead">
		<tr>
			<td> </td>
			<td>
				<b>
					<xsl:apply-templates select="head01"/>
				</b>
			</td>
			<td>
				<b>
					<xsl:apply-templates select="head02"/>
				</b>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronitem">
		<!--Determine if there are event groups.-->
		<xsl:choose>
			<xsl:when test="eventgrp">
				<!--Put the date and first event on the first line.-->
				<tr>
					<td> </td>
					<td valign="top">
						<xsl:apply-templates select="date"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="eventgrp/event[position()=1]"/>
					</td>
				</tr>
				<!--Put each successive event on another line.-->
				<xsl:for-each select="eventgrp/event[not(position()=1)]">
					<tr>
						<td> </td>
						<td> </td>
						<td valign="top">
							<xsl:apply-templates select="."/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:when>
			<!--Put the date and event on a single line.-->
			<xsl:otherwise>
				<tr>
					<td> </td>
					<td valign="top">
						<xsl:apply-templates select="date"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="event"/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
  
  <!-- DAO -->
  <xsl:template match="daogrp">
        <div class="section" id="daogrp">
            <xsl:choose>
                <xsl:when test="parent::archdesc">
                    <h3>
                        <xsl:call-template name="anchor"/>
                        <xsl:choose>
                            <xsl:when test="@ns2:title">
                                <xsl:value-of select="@ns2:title"/>
                            </xsl:when>
                            <xsl:otherwise> Digital Archival Object </xsl:otherwise>
                        </xsl:choose>
                    </h3>
                </xsl:when>
                <xsl:otherwise>
                    <h4>
                        <xsl:call-template name="anchor"/>
                        <xsl:choose>
                            <xsl:when test="@ns2:title">
                                <xsl:value-of select="@ns2:title"/>
                            </xsl:when>
                            <xsl:otherwise> Digital Archival Object </xsl:otherwise>
                        </xsl:choose>
                    </h4>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
 
  <xsl:template match="dao">     
    <div class="dao">
      <a>
        <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
        <xsl:value-of select="daodesc"/>
      </a>
    </div>
  </xsl:template>
  
    
  <xsl:template match="bioghist">		
			<xsl:apply-templates/>			
	</xsl:template>
  
  <xsl:template match="p">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <xsl:template match="persname">
    <span class="persname" itemprop="about" itemscope="" itemtype="http://schema.org/Person">
      <span itemprop="name">
        <xsl:value-of select="."/>
      </span>
    </span>
  </xsl:template>
  
  <xsl:template match="geogname">
    <span class="geogname" itemprop="about" itemscope="" itemtype="http://schema.org/Place">
      <span itemprop="name">
        <xsl:value-of select="."/>
      </span>
    </span>
  </xsl:template>
  
  <xsl:template match="corpname">
    <span class="corpname" itemprop="about" itemscope="" itemtype="http://schema.org/Organization">
      <span itemprop="name">
        <xsl:value-of select="."/>
      </span>
    </span>
  </xsl:template>
  
  <xsl:template match="controlaccess">
      <div class="controlaccess"><xsl:apply-templates/></div>
  </xsl:template>
  
</xsl:stylesheet>