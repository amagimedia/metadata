<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:media="http://search.yahoo.com/mrss/"
                xmlns:wurl="http://api.wurl.com/wurlrss/1.0"
                xmlns:amg="https://www.amagi.com/rss/03"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
                exclude-result-prefixes="xsl media wurl amg">
    <xsl:template match="*[local-name()='channel']">
        <rdf:RDF>
            <xsl:apply-templates select="item"/>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="item[@amg:asset_type='Episode']">
        <ebucore:Episode rdf:nodeID="amgEpisode_{generate-id()}">
            <xsl:if test="wurl:cuepoints">
                <ebucore:cuePoints><xsl:value-of select="wurl:cuepoints"/></ebucore:cuePoints>
            </xsl:if>
            <xsl:if test="wurl:episode/wurl:firstAired">
                <ebucore:dateBroadcast><xsl:value-of select="wurl:episode/wurl:firstAired"/></ebucore:dateBroadcast>
            </xsl:if>
            <xsl:if test="wurl:episode/wurl:episodeNumber">
                <ebucore:episodeNumber><xsl:value-of select="wurl:episode/wurl:episodeNumber"/></ebucore:episodeNumber>
            </xsl:if>

            <xsl:for-each select="link">
                <ebucore:hasAssociatedRelation>
                    <ebucore:Relation rdf:nodeID="amgLink_{generate-id(.)}">
                        <ebucore:relationLink><xsl:value-of select="."/></ebucore:relationLink>
                    </ebucore:Relation>
                </ebucore:hasAssociatedRelation>
            </xsl:for-each>

            <xsl:for-each select="amg:genre">
                <xsl:variable name="genre_id" select="."/>
                <ebucore:hasGenre>
                    <ebucore:Genre rdf:nodeID="amgGenre_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="http://www.ebu.ch/metadata/ontologies/skos/ebu_ContentGenreCS#_{$genre_id}"/>
                        <ebucore:title><xsl:value-of select="@label"/></ebucore:title>
                    </ebucore:Genre>
                </ebucore:hasGenre>
            </xsl:for-each>

            <xsl:for-each select="media:rating">
                <xsl:variable name="rating_id" select="."/>
                <ebucore:hasTargetAudience>
                    <ebucore:TargetAudience rdf:nodeID="amgRating_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="http://www.ebu.ch/metadata/ontologies/skos/ebu_ParentalGuidanceCodeCS#_{$rating_id}"/>
                        <ebucore:title><xsl:value-of select="@label"/></ebucore:title>
                    </ebucore:TargetAudience>
                </ebucore:hasTargetAudience>
            </xsl:for-each>

            <xsl:for-each select="media:category">
                <xsl:variable name="category_id" select="."/>
                <ebucore:hasTopic>
                    <ebucore:Topic rdf:nodeID="amgCategory_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="https://cv.iptc.org/newscodes/mediatopic/{$category_id}"/>
                        <ebucore:title><xsl:value-of select="@label"/></ebucore:title>
                    </ebucore:Topic>
                </ebucore:hasTopic>
            </xsl:for-each>

            <xsl:for-each select="media:credit">
                <xsl:variable name="role_id" select="@code"/>
                <ebucore:hasParticipatingAgent>
                    <ebucore:Agent rdf:nodeID="amgCredit_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="http://www.ebu.ch/metadata/ontologies/skos/ebu_RoleCodeCS#_{$role_id}"/>
                        <ebucore:hasRole><xsl:value-of select="@role"/></ebucore:hasRole>
                        <ebucore:agentName><xsl:value-of select="."/></ebucore:agentName>
                    </ebucore:Agent>
                </ebucore:hasParticipatingAgent>
            </xsl:for-each>

            <ebucore:hasIdentifier>
                <ebucore:Identifier rdf:nodeID="amgGuid_{generate-id(guid)}">
                    <ebucore:formatId>urn:amg:mrss:item:pub:guid</ebucore:formatId>
                    <ebucore:identifierValue><xsl:value-of select="guid"/></ebucore:identifierValue>
                </ebucore:Identifier>
            </ebucore:hasIdentifier>

            <xsl:if test="amg:assetid">
                <ebucore:hasIdentifier>
                    <ebucore:Identifier rdf:nodeID="amgId_{generate-id(amg:assetid)}">
                        <ebucore:hasIdentifierType>urn:amagi:publisher:assetid</ebucore:hasIdentifierType>
                        <ebucore:identifierValue><xsl:value-of select="amg:assetid"/></ebucore:identifierValue>
                    </ebucore:Identifier>
                </ebucore:hasIdentifier>
            </xsl:if>

            <xsl:for-each select="media:keywords">
                <ebucore:hasKeyword><xsl:value-of select="."/></ebucore:hasKeyword>
            </xsl:for-each>

            <xsl:if test="amg:language">
                <xsl:variable name="lang_id" select="amg:language"/>
                <ebucore:hasLanguage>
                    <ebucore:Language rdf:nodeID="amgLanguage_{generate-id(amg:language)}">
                        <ebucore:hasResourceLocator rdf:resource="https://www.ebu.ch/metadata/ontologies/skos/ebu_ISO639_2LanguageCodeCS.htm#_{$lang_id}"/>
                        <ebucore:hasOriginalLanguage><xsl:value-of select="amg:language/@label"/></ebucore:hasOriginalLanguage>
                    </ebucore:Language>
                </ebucore:hasLanguage>
            </xsl:if>

            <ebucore:hasPublisher>
                <ebucore:Agent rdf:nodeID="amgPublisher_{generate-id(../title)}">
                    <xsl:if test="../description">
                        <ebucore:agentDescription><xsl:value-of select="../description"/></ebucore:agentDescription>
                    </xsl:if>
                    <xsl:if test="../link">
                        <xsl:for-each select="../link">
                            <ebucore:agentLinkedData><xsl:value-of select="../link"/></ebucore:agentLinkedData>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="../title">
                        <ebucore:agentName><xsl:value-of select="../title"/></ebucore:agentName>
                    </xsl:if>
                    <xsl:if test="../pubDate">
                        <ebucore:dateBroadcast><xsl:value-of select="../pubDate"/></ebucore:dateBroadcast>
                    </xsl:if>
                    <xsl:if test="../image/@url">
                        <ebucore:hasAgentRelatedPicture><xsl:value-of select="../image/@url"/></ebucore:hasAgentRelatedPicture>
                    </xsl:if>
                </ebucore:Agent>
            </ebucore:hasPublisher>

            <xsl:for-each select="media:thumbnail">
                <ebucore:hasRelatedImage>
                    <ebucore:Thumbnail rdf:nodeID="amgThumbnail_{generate-id(.)}">
                        <ebucore:hasResourceLocator><xsl:value-of select="@url"/></ebucore:hasResourceLocator>
                    </ebucore:Thumbnail>
                </ebucore:hasRelatedImage>
            </xsl:for-each>

            <xsl:for-each select="media:group/media:content">
                <ebucore:hasRelatedMediaResource>
                    <ebucore:MediaResource rdf:nodeID="amgContent_{generate-id()}">
                        <xsl:if test="string-length(@channels)>0">
                            <ebucore:audioChannelNumber><xsl:value-of select="@channels"/></ebucore:audioChannelNumber>
                        </xsl:if>

                        <xsl:if test="string-length(@duration)>0">
                            <ebucore:duration><xsl:value-of select="@duration"/></ebucore:duration>
                        </xsl:if>

                        <xsl:if test="string-length(@fileSize)>0">
                            <ebucore:fileSize><xsl:value-of select="@fileSize"/></ebucore:fileSize>
                        </xsl:if>

                        <xsl:if test="string-length(@framerate)>0">
                            <ebucore:frameRate><xsl:value-of select="@framerate"/></ebucore:frameRate>
                        </xsl:if>

                        <xsl:if test="string-length(@type)>0">
                            <ebucore:hasContainerEncodingFormat><xsl:value-of select="@type"/></ebucore:hasContainerEncodingFormat>
                        </xsl:if>

                        <xsl:if test="string-length(@expression)>0">
                            <ebucore:hasExpression><xsl:value-of select="@expression"/></ebucore:hasExpression>
                        </xsl:if>

                        <xsl:if test="string-length(@amg:lang)>0">
                            <ebucore:hasLanguage><xsl:value-of select="@amg:lang"/></ebucore:hasLanguage>
                        </xsl:if>

                        <xsl:if test="string-length(@url)>0">
                            <ebucore:hasLocator><xsl:value-of select="@url"/></ebucore:hasLocator>
                        </xsl:if>

                        <xsl:if test="string-length(@medium)>0">
                            <ebucore:hasMedium><xsl:value-of select="@medium"/></ebucore:hasMedium>
                        </xsl:if>

                        <xsl:if test="../../media:subTitle">
                            <xsl:for-each select="../../media:subTitle">
                                <ebucore:hasSubtitling>
                                    <ebucore:ClosedSubtitling rdf:nodeID="amgSubTitle_{generate-id(.)}">
                                        <xsl:if test="string-length(@href)>0">
                                            <ebucore:hasResourceLocator><xsl:value-of select="@href"/></ebucore:hasResourceLocator>
                                        </xsl:if>

                                        <xsl:if test="string-length(@type)>0">
                                            <ebucore:hasContainerEncodingFormat><xsl:value-of select="@type"/></ebucore:hasContainerEncodingFormat>
                                        </xsl:if>

                                        <xsl:if test="string-length(@amg:lang)>0">
                                            <ebucore:hasLanguage><xsl:value-of select="@amg:lang"/></ebucore:hasLanguage>
                                        </xsl:if>
                                    </ebucore:ClosedSubtitling>
                                </ebucore:hasSubtitling>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:for-each select="../../amg:audiotracks/media:content">
                            <ebucore:hasAudioTrack>
                                <ebucore:AudioTrack rdf:nodeID="amgAudio_{generate-id(.)}">
                                    <xsl:if test="string-length(@duration)>0">
                                        <ebucore:duration><xsl:value-of select="@duration"/></ebucore:duration>
                                    </xsl:if>

                                    <xsl:if test="string-length(@type)>0">
                                        <ebucore:hasContainerEncodingFormat><xsl:value-of select="@type"/></ebucore:hasContainerEncodingFormat>
                                    </xsl:if>

                                    <xsl:if test="string-length(@amg:lang)>0">
                                        <ebucore:hasLanguage><xsl:value-of select="@amg:lang"/></ebucore:hasLanguage>
                                    </xsl:if>

                                    <xsl:if test="string-length(@url)>0">
                                        <ebucore:hasLocator><xsl:value-of select="@url"/></ebucore:hasLocator>
                                    </xsl:if>

                                    <xsl:if test="string-length(@fileSize)>0">
                                        <ebucore:fileSize><xsl:value-of select="@fileSize"/></ebucore:fileSize>
                                    </xsl:if>
                                </ebucore:AudioTrack>
                            </ebucore:hasAudioTrack>
                        </xsl:for-each>

                        <xsl:if test="string-length(@height)>0">
                            <ebucore:height><xsl:value-of select="@height"/></ebucore:height>
                        </xsl:if>

                        <xsl:if test="string-length(@isDefault)>0">
                            <ebucore:isDefault><xsl:value-of select="@isDefault"/></ebucore:isDefault>
                        </xsl:if>

                        <xsl:if test="string-length(@samplingrate)>0">
                            <ebucore:samplingRate><xsl:value-of select="@samplingrate"/></ebucore:samplingRate>
                        </xsl:if>

                        <xsl:if test="string-length(@bitrate)>0">
                            <ebucore:videoBitRate><xsl:value-of select="@bitrate"/></ebucore:videoBitRate>
                        </xsl:if>

                        <xsl:if test="string-length(@width)>0">
                            <ebucore:width><xsl:value-of select="@width"/></ebucore:width>
                        </xsl:if>

                    </ebucore:MediaResource>
                </ebucore:hasRelatedMediaResource>
            </xsl:for-each>

            <xsl:for-each select="amg:territoryallowed">
                <ebucore:isCoveredBy>
                    <ebucore:Rights rdf:nodeID="amgTerritoryAllowed_{generate-id(.)}">
                        <xsl:if test="@start">
                            <ebucore:rightsEndDateTime><xsl:value-of select="@start"/></ebucore:rightsEndDateTime>
                        </xsl:if>
                        <xsl:if test="@end">
                            <ebucore:rightsStartDateTime><xsl:value-of select="@end"/></ebucore:rightsStartDateTime>
                        </xsl:if>
                        <xsl:if test=".">
                            <ebucore:rightsTerritoryIncludes><xsl:value-of select="."/></ebucore:rightsTerritoryIncludes>
                        </xsl:if>
                    </ebucore:Rights>
                </ebucore:isCoveredBy>
            </xsl:for-each>

            <xsl:for-each select="amg:territorydenied">
                <ebucore:isCoveredBy>
                    <ebucore:Rights rdf:nodeID="amgTerritoryDenied_{generate-id(.)}">
                        <xsl:if test="@start">
                            <ebucore:rightsEndDateTime><xsl:value-of select="@start"/></ebucore:rightsEndDateTime>
                        </xsl:if>
                        <xsl:if test="@end">
                            <ebucore:rightsStartDateTime><xsl:value-of select="@end"/></ebucore:rightsStartDateTime>
                        </xsl:if>
                        <xsl:if test=".">
                            <ebucore:rightsTerritoryExcludes><xsl:value-of select="."/></ebucore:rightsTerritoryExcludes>
                        </xsl:if>
                    </ebucore:Rights>
                </ebucore:isCoveredBy>
            </xsl:for-each>

            <xsl:choose>
                <xsl:when test="wurl:series">
                    <xsl:if test="wurl:episode/wurl:seasonNumber">
                        <ebucore:isEpisodeOfSeason>
                            <ebucore:Season rdf:nodeID="amgSeason_{generate-id(wurl:episode)}">
                                <ebucore:seasonNumber><xsl:value-of select="wurl:episode/wurl:seasonNumber"/></ebucore:seasonNumber>
                            </ebucore:Season>
                        </ebucore:isEpisodeOfSeason>
                    </xsl:if>

                    <xsl:if test="wurl:series/wurl:officialTitle">
                        <ebucore:isEpisodeOfSeries>
                            <ebucore:Series rdf:nodeID="amgSeries_{generate-id(wurl:series)}">
                                <xsl:if test="wurl:series/wurl:startYear">
                                    <ebucore:dateBroadcast><xsl:value-of select="wurl:series/wurl:startYear"/></ebucore:dateBroadcast>
                                </xsl:if>

                                <xsl:if test="wurl:series/wurl:season/wurl:seasonNumber">
                                    <ebucore:hasSeason>
                                        <ebucore:Season rdf:nodeID="{generate-id(wurl:series/wurl:season)}">
                                            <ebucore:seasonNumber><xsl:value-of select="wurl:series/wurl:season/wurl:seasonNumber"/></ebucore:seasonNumber>
                                        </ebucore:Season>
                                    </ebucore:hasSeason>
                                </xsl:if>

                                <ebucore:isSeriesOf><xsl:value-of select="../title"/></ebucore:isSeriesOf>

                                <ebucore:title><xsl:value-of select="wurl:series/wurl:officialTitle"/></ebucore:title>
                            </ebucore:Series>
                        </ebucore:isEpisodeOfSeries>
                    </xsl:if>
                </xsl:when>

                <xsl:otherwise>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:for-each select="media:scenes/media:scene">
                <ebucore:hasActionRelatedScene>
                    <ebucore:Scene rdf:nodeID="amgScene_{generate-id(.)}">
                        <xsl:if test="sceneTitle">
                            <ebucore:title><xsl:value-of select="sceneTitle"/></ebucore:title>
                        </xsl:if>

                        <xsl:if test="sceneDescription">
                            <ebucore:synopsis><xsl:value-of select="sceneDescription"/></ebucore:synopsis>
                        </xsl:if>

                        <xsl:if test="sceneStartTime">
                            <ebucore:textLineStartTime><xsl:value-of select="sceneStartTime"/></ebucore:textLineStartTime>
                        </xsl:if>

                        <xsl:if test="sceneEndTime">
                            <ebucore:textLineEndTime><xsl:value-of select="sceneEndTime"/></ebucore:textLineEndTime>
                        </xsl:if>
                    </ebucore:Scene>
                </ebucore:hasActionRelatedScene>
            </xsl:for-each>

            <xsl:if test="media:description">
                <ebucore:synopsis><xsl:value-of select="media:description"/></ebucore:synopsis>
            </xsl:if>

            <xsl:if test="media:title">
                <ebucore:title><xsl:value-of select="media:title"/></ebucore:title>
            </xsl:if>

        </ebucore:Episode>

    </xsl:template>

    <xsl:template match="item[@amg:asset_type='Feature']">
        <ebucore:Feature rdf:nodeID="amgFeature_{generate-id()}">
            <xsl:if test="wurl:cuepoints">
                <ebucore:cuePoints><xsl:value-of select="wurl:cuepoints"/></ebucore:cuePoints>
            </xsl:if>
            <xsl:if test="wurl:episode/wurl:firstAired">
                <ebucore:dateBroadcast><xsl:value-of select="wurl:episode/wurl:firstAired"/></ebucore:dateBroadcast>
            </xsl:if>
            <xsl:if test="wurl:episode/wurl:episodeNumber">
                <ebucore:episodeNumber><xsl:value-of select="wurl:episode/wurl:episodeNumber"/></ebucore:episodeNumber>
            </xsl:if>

            <xsl:for-each select="link">
                <ebucore:hasAssociatedRelation>
                    <ebucore:Relation rdf:nodeID="amgLink_{generate-id(.)}">
                        <ebucore:relationLink><xsl:value-of select="."/></ebucore:relationLink>
                    </ebucore:Relation>
                </ebucore:hasAssociatedRelation>
            </xsl:for-each>

            <xsl:for-each select="amg:genre">
                <xsl:variable name="genre_id" select="."/>
                <ebucore:hasGenre>
                    <ebucore:Genre rdf:nodeID="amgGenre_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="http://www.ebu.ch/metadata/ontologies/skos/ebu_ContentGenreCS#_{$genre_id}"/>
                        <ebucore:title><xsl:value-of select="@label"/></ebucore:title>
                    </ebucore:Genre>
                </ebucore:hasGenre>
            </xsl:for-each>

            <xsl:for-each select="media:rating">
                <xsl:variable name="rating_id" select="."/>
                <ebucore:hasTargetAudience>
                    <ebucore:TargetAudience rdf:nodeID="amgRating_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="http://www.ebu.ch/metadata/ontologies/skos/ebu_ParentalGuidanceCodeCS#_{$rating_id}"/>
                        <ebucore:title><xsl:value-of select="@label"/></ebucore:title>
                    </ebucore:TargetAudience>
                </ebucore:hasTargetAudience>
            </xsl:for-each>

            <xsl:for-each select="media:category">
                <xsl:variable name="category_id" select="."/>
                <ebucore:hasTopic>
                    <ebucore:Topic rdf:nodeID="amgCategory_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="https://cv.iptc.org/newscodes/mediatopic/{$category_id}"/>
                        <ebucore:title><xsl:value-of select="@label"/></ebucore:title>
                    </ebucore:Topic>
                </ebucore:hasTopic>
            </xsl:for-each>

            <xsl:for-each select="media:credit">
                <xsl:variable name="role_id" select="@code"/>
                <ebucore:hasParticipatingAgent>
                    <ebucore:Agent rdf:nodeID="amgCredit_{generate-id(.)}">
                        <ebucore:hasResourceLocator rdf:resource="http://www.ebu.ch/metadata/ontologies/skos/ebu_RoleCodeCS#_{$role_id}"/>
                        <ebucore:hasRole><xsl:value-of select="@role"/></ebucore:hasRole>
                        <ebucore:agentName><xsl:value-of select="."/></ebucore:agentName>
                    </ebucore:Agent>
                </ebucore:hasParticipatingAgent>
            </xsl:for-each>

            <xsl:if test="guid">
                <ebucore:hasIdentifier>
                    <ebucore:Identifier rdf:nodeID="amgGuid_{generate-id(guid)}">
                        <ebucore:formatId>urn:amg:mrss:item:pub:guid</ebucore:formatId>
                        <ebucore:identifierValue><xsl:value-of select="guid"/></ebucore:identifierValue>
                    </ebucore:Identifier>
                </ebucore:hasIdentifier>
            </xsl:if>

            <xsl:if test="amg:assetid">
                <ebucore:hasIdentifier>
                    <ebucore:Identifier rdf:nodeID="amgId_{generate-id(amg:assetid)}">
                        <ebucore:hasIdentifierType>urn:amagi:publisher:assetid</ebucore:hasIdentifierType>
                        <ebucore:identifierValue><xsl:value-of select="amg:assetid"/></ebucore:identifierValue>
                    </ebucore:Identifier>
                </ebucore:hasIdentifier>
            </xsl:if>

            <xsl:for-each select="media:keywords">
                <ebucore:hasKeyword><xsl:value-of select="."/></ebucore:hasKeyword>
            </xsl:for-each>

            <xsl:if test="amg:language">
                <xsl:variable name="lang_id" select="amg:language"/>
                <ebucore:hasLanguage>
                    <ebucore:Language rdf:nodeID="amgLanguage_{generate-id(amg:language)}">
                        <ebucore:hasResourceLocator rdf:resource="https://www.ebu.ch/metadata/ontologies/skos/ebu_ISO639_2LanguageCodeCS.htm#_{$lang_id}"/>
                        <ebucore:hasOriginalLanguage><xsl:value-of select="amg:language/@label"/></ebucore:hasOriginalLanguage>
                    </ebucore:Language>
                </ebucore:hasLanguage>
            </xsl:if>

            <ebucore:hasPublisher>
                <ebucore:Agent rdf:nodeID="amgPublisher_{generate-id(../title)}">
                    <xsl:if test="../description">
                        <ebucore:agentDescription><xsl:value-of select="../description"/></ebucore:agentDescription>
                    </xsl:if>
                    <xsl:if test="../link">
                        <xsl:for-each select="../link">
                            <ebucore:agentLinkedData><xsl:value-of select="../link"/></ebucore:agentLinkedData>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="../title">
                        <ebucore:agentName><xsl:value-of select="../title"/></ebucore:agentName>
                    </xsl:if>
                    <xsl:if test="../pubDate">
                        <ebucore:dateBroadcast><xsl:value-of select="../pubDate"/></ebucore:dateBroadcast>
                    </xsl:if>
                    <xsl:if test="../image/@url">
                        <ebucore:hasAgentRelatedPicture><xsl:value-of select="../image/@url"/></ebucore:hasAgentRelatedPicture>
                    </xsl:if>
                </ebucore:Agent>
            </ebucore:hasPublisher>

            <xsl:for-each select="media:thumbnail">
                <ebucore:hasRelatedImage>
                    <ebucore:Thumbnail rdf:nodeID="amgThumbnail_{generate-id(.)}">
                        <ebucore:hasResourceLocator><xsl:value-of select="@url"/></ebucore:hasResourceLocator>
                    </ebucore:Thumbnail>
                </ebucore:hasRelatedImage>
            </xsl:for-each>

            <xsl:for-each select="media:group/media:content">
                <ebucore:hasRelatedMediaResource>
                    <ebucore:MediaResource rdf:nodeID="amgContent_{generate-id()}">
                        <xsl:if test="string-length(@channels)>0">
                            <ebucore:audioChannelNumber><xsl:value-of select="@channels"/></ebucore:audioChannelNumber>
                        </xsl:if>

                        <xsl:if test="string-length(@duration)>0">
                            <ebucore:duration><xsl:value-of select="@duration"/></ebucore:duration>
                        </xsl:if>

                        <xsl:if test="string-length(@fileSize)>0">
                            <ebucore:fileSize><xsl:value-of select="@fileSize"/></ebucore:fileSize>
                        </xsl:if>

                        <xsl:if test="string-length(@framerate)>0">
                            <ebucore:frameRate><xsl:value-of select="@framerate"/></ebucore:frameRate>
                        </xsl:if>

                        <xsl:if test="string-length(@type)>0">
                            <ebucore:hasContainerEncodingFormat><xsl:value-of select="@type"/></ebucore:hasContainerEncodingFormat>
                        </xsl:if>

                        <xsl:if test="string-length(@expression)>0">
                            <ebucore:hasExpression><xsl:value-of select="@expression"/></ebucore:hasExpression>
                        </xsl:if>

                        <xsl:if test="string-length(@amg:lang)>0">
                            <ebucore:hasLanguage><xsl:value-of select="@amg:lang"/></ebucore:hasLanguage>
                        </xsl:if>

                        <xsl:if test="string-length(@url)>0">
                            <ebucore:hasLocator><xsl:value-of select="@url"/></ebucore:hasLocator>
                        </xsl:if>

                        <xsl:if test="string-length(@medium)>0">
                            <ebucore:hasMedium><xsl:value-of select="@medium"/></ebucore:hasMedium>
                        </xsl:if>

                        <xsl:if test="../../media:subTitle">
                            <xsl:for-each select="../../media:subTitle">
                                <ebucore:hasSubtitling>
                                    <ebucore:ClosedSubtitling rdf:nodeID="amgSubTitle_{generate-id(.)}">
                                        <xsl:if test="string-length(@href)>0">
                                            <ebucore:hasResourceLocator><xsl:value-of select="@href"/></ebucore:hasResourceLocator>
                                        </xsl:if>

                                        <xsl:if test="string-length(@type)>0">
                                            <ebucore:hasContainerEncodingFormat><xsl:value-of select="@type"/></ebucore:hasContainerEncodingFormat>
                                        </xsl:if>

                                        <xsl:if test="string-length(@amg:lang)>0">
                                            <ebucore:hasLanguage><xsl:value-of select="@amg:lang"/></ebucore:hasLanguage>
                                        </xsl:if>
                                    </ebucore:ClosedSubtitling>
                                </ebucore:hasSubtitling>
                            </xsl:for-each>
                        </xsl:if>

                        <xsl:for-each select="../../amg:audiotracks/media:content">
                            <ebucore:hasAudioTrack>
                                <ebucore:AudioTrack rdf:nodeID="amgAudio_{generate-id(.)}">
                                    <xsl:if test="string-length(@duration)>0">
                                        <ebucore:duration><xsl:value-of select="@duration"/></ebucore:duration>
                                    </xsl:if>

                                    <xsl:if test="string-length(@type)>0">
                                        <ebucore:hasContainerEncodingFormat><xsl:value-of select="@type"/></ebucore:hasContainerEncodingFormat>
                                    </xsl:if>

                                    <xsl:if test="string-length(@amg:lang)>0">
                                        <ebucore:hasLanguage><xsl:value-of select="@amg:lang"/></ebucore:hasLanguage>
                                    </xsl:if>

                                    <xsl:if test="string-length(@url)>0">
                                        <ebucore:hasLocator><xsl:value-of select="@url"/></ebucore:hasLocator>
                                    </xsl:if>

                                    <xsl:if test="string-length(@fileSize)>0">
                                        <ebucore:fileSize><xsl:value-of select="@fileSize"/></ebucore:fileSize>
                                    </xsl:if>
                                </ebucore:AudioTrack>
                            </ebucore:hasAudioTrack>
                        </xsl:for-each>

                        <xsl:if test="string-length(@height)>0">
                            <ebucore:height><xsl:value-of select="@height"/></ebucore:height>
                        </xsl:if>

                        <xsl:if test="string-length(@isDefault)>0">
                            <ebucore:isDefault><xsl:value-of select="@isDefault"/></ebucore:isDefault>
                        </xsl:if>

                        <xsl:if test="string-length(@samplingrate)>0">
                            <ebucore:samplingRate><xsl:value-of select="@samplingrate"/></ebucore:samplingRate>
                        </xsl:if>

                        <xsl:if test="string-length(@bitrate)>0">
                            <ebucore:videoBitRate><xsl:value-of select="@bitrate"/></ebucore:videoBitRate>
                        </xsl:if>

                        <xsl:if test="string-length(@width)>0">
                            <ebucore:width><xsl:value-of select="@width"/></ebucore:width>
                        </xsl:if>

                    </ebucore:MediaResource>
                </ebucore:hasRelatedMediaResource>
            </xsl:for-each>

            <xsl:for-each select="amg:territoryallowed">
                <ebucore:isCoveredBy>
                    <ebucore:Rights rdf:nodeID="amgTerritoryAllowed_{generate-id(.)}">
                        <xsl:if test="@start">
                            <ebucore:rightsEndDateTime><xsl:value-of select="@start"/></ebucore:rightsEndDateTime>
                        </xsl:if>
                        <xsl:if test="@end">
                            <ebucore:rightsStartDateTime><xsl:value-of select="@end"/></ebucore:rightsStartDateTime>
                        </xsl:if>
                        <xsl:if test=".">
                            <ebucore:rightsTerritoryIncludes><xsl:value-of select="."/></ebucore:rightsTerritoryIncludes>
                        </xsl:if>
                    </ebucore:Rights>
                </ebucore:isCoveredBy>
            </xsl:for-each>

            <xsl:for-each select="amg:territorydenied">
                <ebucore:isCoveredBy>
                    <ebucore:Rights rdf:nodeID="amgTerritoryDenied_{generate-id(.)}">
                        <xsl:if test="@start">
                            <ebucore:rightsEndDateTime><xsl:value-of select="@start"/></ebucore:rightsEndDateTime>
                        </xsl:if>
                        <xsl:if test="@end">
                            <ebucore:rightsStartDateTime><xsl:value-of select="@end"/></ebucore:rightsStartDateTime>
                        </xsl:if>
                        <xsl:if test=".">
                            <ebucore:rightsTerritoryExcludes><xsl:value-of select="."/></ebucore:rightsTerritoryExcludes>
                        </xsl:if>
                    </ebucore:Rights>
                </ebucore:isCoveredBy>
            </xsl:for-each>

            <xsl:for-each select="media:scenes/media:scene">
                <ebucore:hasActionRelatedScene>
                    <ebucore:Scene rdf:nodeID="amgScene_{generate-id(.)}">
                        <xsl:if test="sceneTitle">
                            <ebucore:title><xsl:value-of select="sceneTitle"/></ebucore:title>
                        </xsl:if>

                        <xsl:if test="sceneDescription">
                            <ebucore:synopsis><xsl:value-of select="sceneDescription"/></ebucore:synopsis>
                        </xsl:if>

                        <xsl:if test="sceneStartTime">
                            <ebucore:textLineStartTime><xsl:value-of select="sceneStartTime"/></ebucore:textLineStartTime>
                        </xsl:if>

                        <xsl:if test="sceneEndTime">
                            <ebucore:textLineEndTime><xsl:value-of select="sceneEndTime"/></ebucore:textLineEndTime>
                        </xsl:if>
                    </ebucore:Scene>
                </ebucore:hasActionRelatedScene>
            </xsl:for-each>

            <xsl:if test="media:description">
                <ebucore:synopsis><xsl:value-of select="media:description"/></ebucore:synopsis>
            </xsl:if>

            <xsl:if test="media:title">
                <ebucore:title><xsl:value-of select="media:title"/></ebucore:title>
            </xsl:if>

        </ebucore:Feature>

    </xsl:template>

</xsl:stylesheet>
