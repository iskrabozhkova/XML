<?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
       <xsl:attribute-set name="page-size">                             
            <xsl:attribute name="margin-top">1cm</xsl:attribute>
            <xsl:attribute name="margin-left">2cm</xsl:attribute>
            <xsl:attribute name="margin-right">1cm</xsl:attribute>
            <xsl:attribute name="margin-bottom">1cm</xsl:attribute>
      </xsl:attribute-set>
        
        <xsl:attribute-set name="block-decoration">                      
            <xsl:attribute name="border-color">black</xsl:attribute>
            <xsl:attribute name="border-left-style">solid</xsl:attribute>
          <xsl:attribute name="border-left-width">thin</xsl:attribute>
            <xsl:attribute name="border-top-style">solid</xsl:attribute>
            <xsl:attribute name="border-top-width">thin</xsl:attribute>
            <xsl:attribute name="padding-left">2mm</xsl:attribute>
            <xsl:attribute name="space-after">1mm</xsl:attribute>
      </xsl:attribute-set>
        
        <xsl:attribute-set name="element-formatting">                    
            <xsl:attribute name="font-weight">bold</xsl:attribute>
            <xsl:attribute name="color">green</xsl:attribute>
      </xsl:attribute-set>
    
        <xsl:attribute-set name="attribute-formatting">                  
            <xsl:attribute name="font-style">italic</xsl:attribute>
            <xsl:attribute name="color">blue</xsl:attribute>
     </xsl:attribute-set>
    
        <xsl:template name="define-layout">                              
            <fo:layout-master-set>
                <fo:simple-page-master master-name="a-page" xsl:use-attribute-sets="page-size">
               <fo:region-body xsl:use-attribute-sets="page-size" margin-left="-1.5cm" margin-right="0cm"/>
                    <fo:region-before extent="1cm"/>
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="page-layout">      
                    <fo:repeatable-page-master-reference master-reference="a-page"/>
             </fo:page-sequence-master>
            </fo:layout-master-set>
        </xsl:template>
        
        <xsl:template name="define-header">                            
          <fo:static-content flow-name="xsl-region-before">
                <fo:block text-align-last="justify">
                    <fo:retrieve-marker retrieve-class-name="context"   
                        retrieve-position="first-starting-within-page"/>
                    <fo:leader/>
                 Page <fo:page-number/>
                </fo:block>
            </fo:static-content>
        </xsl:template>
        
     <xsl:template match="/">                                         
            <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">       
                <xsl:call-template name="define-layout"/>
                <fo:page-sequence master-reference="page-layout">        
                 <xsl:call-template name="define-header"/>
                     <fo:flow flow-name="xsl-region-body">                
                        <fo:list-block provisional-distance-between-starts="28mm">
                            <xsl:apply-templates/>                       
                        </fo:list-block>
                    </fo:flow>
              </fo:page-sequence>
            </fo:root>
        </xsl:template>                                                 
        
      <xsl:template match="*">
      <fo:list-item>                                                   
          <fo:list-item-label end-indent="label-end()">
            <fo:block xsl:use-attribute-sets="element-formatting">       
              <xsl:value-of select="local-name()"/>
            </fo:block>
       </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">                
            <xsl:choose>
              <xsl:when test="count(*)=0 and count(@*)=0">              
                <fo:block>
                <fo:inline font-style="normal" color="black">
                    <xsl:value-of select="."/>
                  </fo:inline>
                </fo:block>
              </xsl:when>
            <xsl:otherwise>                                            
                  <fo:block xsl:use-attribute-sets="block-decoration">
                    <fo:marker marker-class-name="context">              
                        <xsl:value-of select="string-join(for $n in ancestor::* 
                                              return local-name($n),' | ')"/>
                  </fo:marker>
                    <fo:list-block>
                      <xsl:apply-templates select="@*|*|text()"/>        
                    </fo:list-block>
                  </fo:block>
            </xsl:otherwise>
            </xsl:choose>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:template>
  
      <xsl:template match="@*">                                          
        <xsl:call-template name="labeledValue">
          <xsl:with-param name="label">
            <fo:inline xsl:use-attribute-sets="attribute-formatting">    
          @<xsl:value-of select="local-name()"/>
            </fo:inline>
          </xsl:with-param>
          <xsl:with-param name="value">                                  
            <fo:inline font-style="normal" color="black">
          <xsl:value-of select="."/>
            </fo:inline>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:template>
 
      <xsl:template match="text()">                                      
        <xsl:variable name="content" select="normalize-space(.)"/>
        <xsl:if test="string-length($content)>0">
          <xsl:call-template name="labeledValue">
         <xsl:with-param name="label">
              <fo:inline/>
            </xsl:with-param>
            <xsl:with-param name="value" select="$content"/>
          </xsl:call-template>
     </xsl:if>
      </xsl:template>
    
      <xsl:template name="labeledValue">                                 
        <xsl:param name="label"/>
     <xsl:param name="value"/>
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block>
              <xsl:copy-of select="$label"/>                             
         </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block>
              <xsl:copy-of select="$value"/>                             
        </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </xsl:template>
    
 </xsl:stylesheet>
    