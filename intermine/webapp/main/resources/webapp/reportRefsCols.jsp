<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%--in order to filter out chars from strings --%>


<!-- reportRefsCols.jsp -->

<html:xhtml />

<tiles:importAttribute name="object" />
<tiles:importAttribute name="placement" />
<tiles:importAttribute name="showTitle" ignore="true" />
<c:if test="${!empty placementRefsAndCollections[placement]}">

  <c:if test="${!empty showTitle && fn:length(placementRefsAndCollections[placement]) > 0}">
    <a name="miscellaneous"><h2>${showTitle}</h2></a>
  </c:if>

  <c:forEach items="${placementRefsAndCollections[placement]}" var="entry">
    <c:set var="collection" value="${entry.value}" />
    <c:set var="fieldName" value="${entry.key}" />

    <c:set var="placementAndField" value="${placement}_${fieldName}" />

        <%-- ############# --%>
        <div class="table loadOnScroll" id="${fn:replace(placement, ":", "_")}${fieldName}_table">
        <h3 class="theme-1-border theme-5-background">
          <c:if test="${IS_SUPERUSER}">
            <span class="tag-editor">
              <c:set var="descriptor" value="${collection.descriptor}" />
              <tiles:insert name="inlineTagEditor.tile">
                <tiles:put name="taggable" beanName="descriptor" />
                <tiles:put name="show" value="true" />
              </tiles:insert>
            </span>
          </c:if>
        <html:link
          styleClass="getTable"
          linkName="${placement}_${fieldName}"
          onclick="return toggleCollectionVisibilityJQuery('${placement}', '${fieldName}', '${object.object.id}', '${param.trail}')"
          action="/modifyDetails?method=unverbosify&amp;field=${fieldName}&amp;placement=${placement}&amp;id=${object.id}&amp;trail=${param.trail}">
          <span class="collectionField theme-1-color">
            ${collection.size}&nbsp;${fieldName}<!-- of type ${collection.descriptor.referencedClassDescriptor.unqualifiedName}-->
          </span>
          <im:typehelp type="${object.classDescriptor.unqualifiedName}.${fieldName}" />
        </html:link></h3>
        <div class="clear"></div>
        <%-- ############# --%>

    <c:choose>
      <c:when test="${collection.size > 0}">
          <div id="coll_${fn:replace(placement, ":", "_")}${fieldName}">
          <div id="coll_${fn:replace(placement, ":", "_")}${fieldName}_inner" style="overflow-x:auto;">

            <c:set var="inlineResultsTable" value="${collection.table}"/>

            <tiles:insert page="/reportCollectionTable.jsp">
              <tiles:put name="inlineResultsTable" beanName="inlineResultsTable" />
              <tiles:put name="object" beanName="object" />
              <tiles:put name="fieldName" value="${fieldName}" />
            </tiles:insert>
            <script type="text/javascript">trimTable('#coll_${fn:replace(placement, ":", "_")}${fieldName}_inner');</script>
          </div>

          <p class="in_table" style="display:none;">
            <html:link styleClass="theme-1-color" action="/collectionDetails?id=${object.id}&amp;field=${fieldName}&amp;trail=${param.trail}">
              Show all in a table »
            </html:link>
          </p>

          </div>
          <div class="clear"></div>
        <%-- ############# --%>
      </c:when>
      <c:otherwise>
        <script type="text/javascript">
          jQuery('#${fn:replace(placement, ":", "_")}${fieldName}_table').addClass('gray');
          var h3 = jQuery('#${fn:replace(placement, ":", "_")}${fieldName}_table').find('h3');
          if (h3.find('span.tag-editor').length > 0) {
            var tags = h3.find('span.tag-editor');
            h3.html(h3.find('a.getTable').text());
            tags.appendTo(h3);
          } else {
            h3.html(h3.find('a.getTable').text());
          }
        </script>
      </c:otherwise>
    </c:choose>
    </div>

  </c:forEach>
</c:if>

<!-- /reportRefsCols.jsp -->