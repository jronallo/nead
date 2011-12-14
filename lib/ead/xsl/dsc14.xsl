<!--Revision date 2 January 2004-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- This stylesheet formats the dsc portion of a finding aid.-->
	<!--It formats components that have 2 container elements of any type.-->
	<!--It assumes that c01 and optionally <c02> and <c03> contains a
	descripton of a series, , subseries, subgroup or subcollection. -->
	<!--Column headings for containers are displayed when either the content or
	the type of a component's first container differs from that of
	the comparable container in the preceding component. -->
	<!-- The text of column headings is taken from the type
    attribute of the container elements.-->
	<!--The content of any and all container elements is always displayed
	along the right side of the screen or page. -->

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
	
<!-- ................Section 2 ...........................-->
<!--This section of the stylesheet contains two named-templates
that are used generically throughout the stylesheet.-->

	<!--This template formats the unitid, origination, unittitle,
	unitdate, and physdesc elements of components at all levels.  They appear on
	a separate line from other did elements. It is generic to all
	component levels.-->
	
	<xsl:template name="component-did">
	<!--If the level of the parent component is subcollection, subgrp,
	series, or subseries, make this text bold.-->
		<xsl:choose>
			<xsl:when test="../@level='subcollection' or ./@level='subgrp'
			or ../@level='series' or ../@level='subseries'">
				<b>
					<xsl:call-template name="component-did-core"/>
				</b>
			</xsl:when>
			<!--Otherwise render the text in its normal font.-->
			<xsl:otherwise>
				<xsl:call-template name="component-did-core"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="component-did-core">

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
	
	
	
<!-- ...............Section 3.............................. -->
<!--This section of the stylesheet creates an HTML table for each c01.
It then recursively processes each child component of the
c01 by calling a named template specific to that component level.
The named templates are in section 4.-->

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
				<td width="12%"> </td>
				<td width="8%"> </td>
			</tr>
			<xsl:call-template name="c01-level"/>	
				
				<xsl:for-each select="c02">
					<xsl:call-template name="c02-level"/>	
					
					<xsl:for-each select="c03">
					<xsl:call-template name="c03-level"/>	

					<xsl:for-each select="c04">
						<xsl:call-template name="c04-level"/>	

						<xsl:for-each select="c05">
							<xsl:call-template name="c05-level"/>	

							<xsl:for-each select="c06">
								<xsl:call-template name="c06-level"/>	

								<xsl:for-each select="c07">
									<xsl:call-template name="c07-level"/>	

									<xsl:for-each select="c08">
										<xsl:call-template name="c08-level"/>	
									</xsl:for-each><!--Closes c08-->
								</xsl:for-each><!--Closes c07-->
							</xsl:for-each><!--Closes c06-->
						</xsl:for-each><!--Closes c05-->
					</xsl:for-each><!--Closes c04-->
				</xsl:for-each><!--Closes c03-->
			</xsl:for-each><!--Closes c02-->
		</table>
	</xsl:template>
	
<!-- ...............Section 4.............................. -->
<!--This section of the stylesheet contains a separate named template for
each component level.  The contents of each is identical except for the
spacing that is inserted to create the proper column display in HTML
for each level.-->

	<xsl:template name="c01-level">
		<xsl:for-each select="did">
			<tr>
				<td colspan="12">
					<b>
						<a>
							<xsl:attribute name="name">
								<xsl:text>series</xsl:text><xsl:number from="dsc" count="c01 "/>
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
		</xsl:for-each><!--Closes the did.-->

		<!--This template creates a separate row for each child of
		the listed elements.-->
		<xsl:for-each select="scopecontent | bioghist | arrangement
			| userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note
			| descgrp/*">
			<xsl:for-each select="head">
				<tr>
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
					<td colspan="8">
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c02 elements that have associated containers, for
	example when c02 is a file.-->
	<xsl:template name="c02-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Oversize' or @type='Volume' or @type='Carton']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Oversize' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variable defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page'  or @type='Reel']"/>

			<!--When the container value or the container type of the first
			 container is not are the same as that of the comparable container
			in the previous component, insert column heads.-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
	 			<tr>
					<td colspan="10"> </td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>	
				<tr>
					<td> </td>
					<td valign="top" colspan="9">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:value-of select="$first"/>
					</td>
					<td valign="top">
						<xsl:value-of select="$second"/>
					</td>
				</tr>
			<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="7" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note | descgrp/*">
			<xsl:for-each select="head">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="7">
						<b>
							<xsl:apply-templates/>
						</b>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
			<xsl:for-each select="*[not(self::head)]">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="7">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>


	<xsl:template name="c03-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variable defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page']"/>

		<!--When the container value or the container type of the first
		 container is not are the same as that of the comparable container
		in the previous component, insert column heads.-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
				<tr>
					<td colspan="10"> </td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>	
				<tr>
					<td> </td>
					<td> </td>
					<td valign="top" colspan="8">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$first"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$second"/>
					</td>
				</tr>
			
			<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="6" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note |
			descgrp/*">
			<xsl:for-each select="head">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="6">
						<b>
							<xsl:apply-templates/>
						</b>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
			<xsl:for-each select="*[not(self::head)]">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="6">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c04 level components.-->
	<xsl:template name="c04-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variable defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page']"/>

			<!--When the container value or the container type of the first
			 container is not are the same as that of the comparable container
			in the previous component, insert column heads.-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
				<tr>
					<td colspan="10"> </td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>	
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td valign="top" colspan="7">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$first"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$second"/>
					</td>
				</tr>
			
			<xsl:for-each select="abstract | note/p | langmaterial | materialspec">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="5" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did-->

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
			<xsl:for-each select="head">
				<tr>
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
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
			<xsl:for-each select="*[not(self::head)]">
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td colspan="5">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c05-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variables defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page']"/>

			<!--When the container value or the container type of the first
			 container is not are the same as that of the comparable container
			in the previous component, insert column heads.-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
				<tr>
					<td colspan="10"> </td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>	
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td valign="top" colspan="6">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$first"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$second"/>
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
					<td colspan="4" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
			<xsl:for-each select="head">
				<tr>
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
					<td> </td>
					<td> </td>
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
					<td colspan="4">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<!--This template processes c06 components.-->
	<xsl:template name="c06-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variable defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page']"/>

		<!--When the container value or the container type of the first
		 container is not are the same as that of the comparable container
		in the previous component, insert column heads.-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
				<tr>
					<td colspan="10"> </td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>	
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td valign="top" colspan="5">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$first"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$second"/>
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
					<td colspan="3" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note |
			descgrp/*">
			<xsl:for-each select="head">
				<tr>
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
					<td> </td>
					<td> </td>
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
					<td colspan="3">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c07-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variable defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page']"/>

			<!--When the container value or the container type of the first
			 container is not are the same as that of the comparable container
			in the previous component, insert column heads-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
				<tr>
					<td colspan="10"></td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td valign="top" colspan="4">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$first"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$second"/>
					</td>
				</tr>
			</xsl:for-each> <!--Closes the did.-->
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
					<td colspan="2" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
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
					<td colspan="2">
						<b>
							<xsl:apply-templates/>
						</b>
					</td>
					<td> </td>
					<td> </td>
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
					<td colspan="2">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="c08-level">
		<xsl:for-each select="did">

		<!--The next two variables define the set of container types that
		may appear in the first column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="first" select="container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>
		<xsl:variable name="preceding" select="preceding::did[1]/container[@type='Box' or @type='Volume' or @type='Carton' or @type='Reel']"/>

		<!--This variable defines the set of container types that
		may appear in the second column of a two column container list.
		Add or subtract container types to fix institutional practice.-->
		<xsl:variable name="second" select="container[@type='Folder' or @type='Frame' or @type='Page']"/>

			<!--When the container value or the container type of the first
			 container is not are the same as that of the comparable container
			in the previous component, insert column heads.-->
			<xsl:if test="not($preceding=$first) or
			not($preceding/@type=$first/@type)">
				<tr>
					<td colspan="10"> </td>
					<td>
						<b>
							<xsl:value-of select="$first/@type"/>
						</b>
					</td>
					<td>
						<b>
							<xsl:value-of select="$second/@type"/>
						</b>
					</td>
				</tr>
			</xsl:if>	
				<tr>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td> </td>
					<td valign="top" colspan="3">
						<xsl:call-template name="component-did"/>
					</td>
					<td valign="top">
						<xsl:value-of select="$first"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="$second"/>
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
					<td colspan="1" valign="top">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each><!--Closes the did.-->

		<xsl:for-each select="scopecontent | bioghist | arrangement |
			descgrp/* | userestrict | accessrestrict | processinfo |
			acqinfo | custodhist | controlaccess/controlaccess | odd | note">
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
					<td colspan="1">
						<b>
							<xsl:apply-templates/>
						</b>
					</td>
					<td> </td>
					<td> </td>
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
					<td colspan="1">
						<xsl:apply-templates/>
					</td>
					<td> </td>
					<td> </td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>