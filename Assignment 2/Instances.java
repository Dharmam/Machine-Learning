

import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.Map;

/**
 * Training data Instances data structure.
 * 
 * @author dharmam
 */
public class Instances {

	private Instance[] instances;
	private Map<String, Integer> header;
	
	public static final String CLASS_NAME = "Class";
	public static MathContext globalMathContext = new MathContext(5, RoundingMode.HALF_EVEN);

	public Instances() {
	}

	public Instances(Instance[] instances) {
		super();
		this.instances = instances;
	}

	public Instance[] getInstances() {
		return instances;
	}

	public void setInstances(Instance[] instances) {
		this.instances = instances;
	}

	public Map<String, Integer> getHeader() {
		return header;
	}

	public void setHeader(Map<String, Integer> header) {
		this.header = header;
	}

	public int size() {
		return (instances != null ? instances.length : 0);
	}

	public InstanceIndexer getIndexer() {
		return new InstanceIndexer(this);
	}

	public Map<Integer, AttributeValue> getAttributeValues(String attributeName) throws MLException {
		AttributeDO[] attributes = getAttributesByName(attributeName);
		Map<Integer, AttributeValue> discreteValuesMap = new HashMap<Integer, AttributeValue>();

		for (AttributeDO attribute : attributes) {
			String name = attribute.getName();
			Integer value = attribute.getValue();
			if (discreteValuesMap.containsKey(value))
				discreteValuesMap.put(value, discreteValuesMap.get(value).incrementAttributeValueCount());
			else
				discreteValuesMap.put(value, new AttributeValue(name, value, 1));
		}

		return discreteValuesMap;
	}

	public Map<Integer, AttributeValue> getAttributeValues(InstanceIndexer instanceIndexer) throws MLException {
		Map<Integer, AttributeValue> attributeValues = null;
		if (instanceIndexer.getAttributeName() != null) {

			AttributeDO[] attributeDOs = getAttributesByName(instanceIndexer.getAttributeName());
			AttributeDO[] classAttributes = getAttributesByName(Instances.CLASS_NAME);
			
			Map<Integer, AttributeValue> discreteValuesMap = new HashMap<Integer, AttributeValue>();

			for (int index = 0; index < attributeDOs.length; index ++) {
				if (instanceIndexer.getIndexes().contains(index)) {
					String name = attributeDOs[index].getName();
					Integer value = attributeDOs[index].getValue();
					AttributeDO classAttributeDO = classAttributes[index];
					
					if (discreteValuesMap.containsKey(value)) {
						discreteValuesMap.put(value, discreteValuesMap.get(value).incrementAttributeValueCount()
								.insertOrIncrementClassifiedCountMap(classAttributeDO.getValue()));
					} else {
						discreteValuesMap.put(value, new AttributeValue(name, value, 1)
								.insertOrIncrementClassifiedCountMap(classAttributeDO.getValue()));
					}
				}
			}
			attributeValues = discreteValuesMap;
			
			// bug fix : if there is only one type of instance attribute type, and hence only one entry in map. 
			if (attributeValues.size() == 1) {
				if (attributeValues.keySet().contains(1)) {
					discreteValuesMap.put(0, new AttributeValue(attributeValues.get(1).getAttributeName(), 0, 0));
				} else {
					discreteValuesMap.put(1, new AttributeValue(attributeValues.get(0).getAttributeName(), 1, 0));
				}
			}
			
		} else {
			throw new MLException("No attribute name mentioned in Indexer, hence cannot provide attribute values !");
		}
		 
		return attributeValues;
	}

	public AttributeDO[] getAttributesByName(String attributeName) throws MLException {
		AttributeDO[] attributeDOs = null;
		if (header.size() > 0 && header.containsKey(attributeName)) {
			Integer attributeIndex = null;

			if ((attributeIndex = header.get(attributeName)) != null) {
				attributeDOs = new AttributeDO[size()];

				for (int index = 0; index < size(); index++)
					attributeDOs[index] = instances[index].getAttributeDOs()[attributeIndex];
			} else {
				throw new MLException(" No attribute found with name : " + attributeName);
			}
		}
		return attributeDOs;
	}
	
	public BigDecimal calculateHeaderEntropy (Map<Integer, AttributeValue> attributeValues) throws MLException {
		BigDecimal headerEntropyresult = new BigDecimal(0);
		
		for (AttributeValue attributeValue : attributeValues.values()) {
			
			BigDecimal fraction = BigDecimal.valueOf(attributeValue.getAttributeValueCount()).divide(new BigDecimal(size()), globalMathContext);
			BigDecimal logFraction = BigDecimal.valueOf(Math.log(fraction.doubleValue())).divide(new BigDecimal(Math.log(2)), globalMathContext);
				
			headerEntropyresult = headerEntropyresult.add(fraction.multiply(logFraction, globalMathContext));
		}
		
		return headerEntropyresult.negate();
	}
	
	public BigDecimal calculateHeaderEntropy (Map<Integer, AttributeValue> attributeValues, boolean withVariance) throws MLException {
		if (!withVariance) {
			return calculateHeaderEntropy(attributeValues);
		} else {
			BigDecimal headerEntropyresult = new BigDecimal(1);
			
			for (AttributeValue attributeValue : attributeValues.values()) {
				BigDecimal fraction = BigDecimal.valueOf(attributeValue.getAttributeValueCount()).divide(new BigDecimal(size()), globalMathContext);
				headerEntropyresult.multiply(fraction, globalMathContext);
			}
			
			return headerEntropyresult;
		}
	}
		
	public BigDecimal calculateEntropy (Map<Integer, AttributeValue> attributeValues) throws MLException {
		BigDecimal attributeEntropyresult = new BigDecimal(0);
		
		for (AttributeValue attributeValue : attributeValues.values()) {
			int attributeCount = attributeValue.getAttributeValueCount();
			
			BigDecimal innerResult = new BigDecimal(0);
			for (Integer corrospondingClassifiedCount : attributeValue.getClassifiedCountMap().values()) {
				
				BigDecimal fraction = BigDecimal.valueOf(corrospondingClassifiedCount).divide(new BigDecimal(attributeCount), globalMathContext);
				BigDecimal logFraction = BigDecimal.valueOf(Math.log(fraction.doubleValue()))
						.divide(new BigDecimal(Math.log(2)), globalMathContext);
				
				innerResult = innerResult.add(fraction.multiply(logFraction, globalMathContext));
			}
			innerResult = innerResult.negate();
			attributeValue.setEntropy(innerResult);
			
			BigDecimal attributeGlobalFraction = BigDecimal.valueOf(attributeValue.getAttributeValueCount()).divide(new BigDecimal(size()), globalMathContext);
			
			attributeEntropyresult = attributeEntropyresult.add(attributeGlobalFraction.multiply(innerResult));
		}

		return attributeEntropyresult;
	}
	
	public BigDecimal calculateEntropy (Map<Integer, AttributeValue> attributeValues, boolean withVariance) throws MLException {
		if (!withVariance) {
			return calculateEntropy(attributeValues);
		} else {
			BigDecimal attributeEntropyresult = new BigDecimal(0);
			
			for (AttributeValue attributeValue : attributeValues.values()) {
				int attributeValueCount = attributeValue.getAttributeValueCount();
				
				BigDecimal innerVarianceResult = new BigDecimal(1);
				for (Integer corrospondingClassifiedCount : attributeValue.getClassifiedCountMap().values()) {
					
					BigDecimal fraction = BigDecimal.valueOf(corrospondingClassifiedCount).divide(new BigDecimal(attributeValueCount), globalMathContext);
					innerVarianceResult.multiply(fraction, globalMathContext);
				}
				
				attributeValue.setEntropy(innerVarianceResult);
				BigDecimal attributeGlobalFraction = BigDecimal.valueOf(attributeValueCount).divide(new BigDecimal(size()), globalMathContext);
				attributeEntropyresult = attributeEntropyresult.add(attributeGlobalFraction.multiply(innerVarianceResult));
			}

			return attributeEntropyresult;
		}
	}

}
