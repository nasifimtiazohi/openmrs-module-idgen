<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ taglib prefix="form" uri="resources/spring-form.tld"%>

<openmrs:require privilege="Manage Identifier Sources" otherwise="/login.htm" redirect="/module/idgen/manageIdentifierSources.form" />

<%@ include file="/WEB-INF/template/header.jsp"%>
<%@ include file="localHeader.jsp"%>

<style>
	#sourceTable th, td {text-align:left; padding-right:10px; white-space:nowrap;}
	.underlineRow td {border-bottom: 1px solid black;}
</style>

<h3>${source.identifierType.name}: ${source.name}</h3>

<table id="sourceTable">
	<tr>
		<th><spring:message code="idgen.sourceName" /></th>
		<td>
			${source.name}
			&nbsp;&nbsp;
			(<a href="editIdentifierSource.form?source=${source.id}"><spring:message code="general.edit" />)
		</td>
	</tr>
	<tr>
		<th><spring:message code="general.description" />:</th>
		<td>${source.description}</td>
	</tr>
	<tr>
		<th><spring:message code="PatientIdentifier.identifierType" /></th>
		<td>${source.identifierType.name}</td>
	</tr>
	<tr>
		<th><spring:message code="idgen.checkDigitAlgorithm" />:</td>
		<td>
			<c:choose>
				<c:when test="${!empty source.identifierType.validator}">
					${source.identifierType.validator}
				</c:when>
				<c:otherwise>
					<spring:message code="general.none" />
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
</table>
<br/>

<c:if test="${source.class.name == 'org.openmrs.module.idgen.SequentialIdentifierGenerator'}">

	This Identifier Source generates sequential identifiers with the following configuration:<br/><br/>
	
	<table id="sourceTable">
		<tr>
			<th><spring:message code="idgen.baseCharacterSet"/>:</th>
			<td>${source.baseCharacterSet}</td>
		</tr>
		<tr>
			<th><spring:message code="idgen.firstIdentifierBase"/>:</th>
			<td>${source.firstIdentifierBase}</td>
		</tr>
		<tr>
			<th><spring:message code="idgen.prefix"/>:</th>
			<td>${source.prefix}</td>
		</tr>
		<tr>
			<th><spring:message code="idgen.suffix"/>:</th>
			<td>${source.suffix}</td>
		</tr>
		<tr>
			<th><spring:message code="idgen.length"/>:</th>
			<td>${source.length}</td>
		</tr>
	</table>
</c:if>

<c:if test="${source.class.name == 'org.openmrs.module.idgen.RemoteIdentifierSource'}">
	This Identifier Source connects to the following remote URL to retrieve new identifiers:<br/>
	${source.url}
</c:if>

<c:if test="${source.class.name == 'org.openmrs.module.idgen.IdentifierPool'}">

	This Identifier Source manages a pool of pre-generated identifiers.<br/><br/>
	
	Quantity Consumed:  ${fn:length(source.usedIdentifiers)}<br/>
	Quantity Available: ${fn:length(source.availableIdentifiers)}
	
	<br/><br/>
	
	<form action="addIdentifiersFromFile.form" method="post" enctype="multipart/form-data">
		The pool can be filled via manual upload from file: 
		<input type="hidden" name="source" value="${source.id}"/>
		<input type="file" name="inputFile"/>
		<input type="submit" value="Upload"/>
	</form>
	
	<c:if test="${!empty source.source}">
		<br/>
		<form action="addIdentifiersFromSource.form" method="post" enctype="multipart/form-data">
			The pool can also be filled by directly connecting to Identifier Source ${source.source.name}.<br/>
			Quantity to upload from ${source.source.name}:
			<input type="hidden" name="source" value="${source.id}"/>
			<input type="input" name="batchSize"/>
			<input type="submit" value="Upload"/>
		</form>
	</c:if>
	<br/>
	
</c:if>
<hr/>
<form action="exportIdentifiers.form">
	<b>Export Identifiers: </b>
	<c:set var="available" value="t"/>
	<c:if test="${source.class.name == 'org.openmrs.module.idgen.IdentifierPool'}">
		<c:if test="${fn:length(source.availableIdentifiers) == 0}">
			<c:set var="available" value="f"/>
		</c:if>
		None available for export.
	</c:if>
	<br/>
	<c:if test="${available == 't'}">
		<input type="hidden" name="source" value="${source.id}"/>
		<table>
			<tr>
				<td><spring:message code="idgen.numberToGenerate" /></td>
				<td><input type="text" name="numberToGenerate" value=""/></td>
			</tr>
			<tr>
				<td><spring:message code="idgen.comment" /></td>
				<td><textarea name="comment" rows="3" cols="20"/></textarea></td>
			</tr>
		</table>
		<input type="submit" value="<spring:message code="idgen.export" />"/>	
	</c:if>
</form>

<%@ include file="/WEB-INF/template/footer.jsp"%>