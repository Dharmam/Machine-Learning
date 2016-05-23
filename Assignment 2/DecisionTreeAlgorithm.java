import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class DecisionTreeAlgorithm {

	private Instances trainingInstances;
	private BigDecimal headerEntropyValue;
	private Node rootNode;
	private int totalDepthSize;
	private int decisionNodesCount;
	private int totalNonLeafNodes;
	
	public DecisionTreeAlgorithm() {
	}

	public Instances getTrainingInstances() {
		return trainingInstances;
	}

	public void setTrainingInstances(Instances trainingInstances) {
		this.trainingInstances = trainingInstances;
	}

	public BigDecimal getHeaderEntropyValue() {
		return headerEntropyValue;
	}

	public void setHeaderEntropyValue(BigDecimal headerEntropyValue) {
		this.headerEntropyValue = headerEntropyValue;
	}

	public Node getRootNode() {
		return rootNode;
	}

	public void setRootNode(Node rootNode) {
		this.rootNode = rootNode;
	}

	public int getDecisionNodesCount() {
		return decisionNodesCount;
	}
	
	public void setDecisionNodesCount(int decisionNodesCount) {
		this.decisionNodesCount = decisionNodesCount;
	}
	
	public int getTotalDepthSize() {
		return totalDepthSize;
	}
	
	public void setTotalDepthSize(int totalDepthSize) {
		this.totalDepthSize = totalDepthSize;
	}
	
	public int getTotalNonLeafNodes() {
		return totalNonLeafNodes;
	}
	
	public void setTotalNonLeafNodes(int totalNonLeafNodes) {
		this.totalNonLeafNodes = totalNonLeafNodes;
	}
	
	public void train(String location) throws MLException {

		// load the data set, process it !
		Instances trainingInstances = Utility.loadInstancesFromData(Utility
				.loadFile(location));
		setTrainingInstances(trainingInstances);

		Map<Integer, AttributeValue> headerAttributeValues = trainingInstances
				.getIndexer()
				.getAttributeInstanceIndexesByName(Instances.CLASS_NAME)
				.getAttributeValues();

		setHeaderEntropyValue(trainingInstances
				.calculateHeaderEntropy(headerAttributeValues));
	}

	public void generateInitialDecisionTree() throws MLException {
		BigDecimal minInitialAttributeEntropy = null;
		Attribute bestInitialAttribute = null;

		for (String attributeName : getTrainingInstances().getHeader().keySet()) {
			if (!attributeName.equals(Instances.CLASS_NAME)) {

				Map<Integer, AttributeValue> attributeValues = getTrainingInstances()
						.getIndexer()
						.getAttributeInstanceIndexesByName(attributeName)
						.getAttributeValues();

				BigDecimal attributeEntropyValue = getTrainingInstances()
						.calculateEntropy(attributeValues);

				if (minInitialAttributeEntropy == null
						|| minInitialAttributeEntropy
						.compareTo(attributeEntropyValue) > 0) {
					minInitialAttributeEntropy = attributeEntropyValue;
					bestInitialAttribute = new Attribute(attributeName,
							attributeValues, attributeEntropyValue);
				}
			}
		}

		bestInitialAttribute.setInformationGain(getHeaderEntropyValue()
				.subtract(minInitialAttributeEntropy,
						Instances.globalMathContext));
		Node rootNode = new Node(null, bestInitialAttribute,
				getTrainingInstances().getIndexer()
				.getAttributeInstanceIndexesByName(
						bestInitialAttribute.getAttributeName()));

		setRootNode(rootNode);
		List<String> processedAttributes = new ArrayList<String>();
		processedAttributes.add(Instances.CLASS_NAME);
		processedAttributes.add(bestInitialAttribute.getAttributeName());
		rootNode.setProcessedAttributes(processedAttributes);
		totalNonLeafNodes ++;

		for (AttributeValue attributeValue : bestInitialAttribute
				.getAttributeValues().values()) {
			if (attributeValue.getEntropy().compareTo(new BigDecimal(0)) != 0) {
				rootNode.getCandidatesNodesList().add(attributeValue);
			}
			attributeValue.setCurrentNode(getRootNode());
		}
	}

	public void generateInitialDecisionTreeRandom() throws MLException {
		BigDecimal minInitialAttributeEntropy = null;
		Attribute bestInitialAttribute = null;
		// Random Generator
		Random gen = new Random();
		int i = gen.nextInt(getTrainingInstances().getHeader().size() - 1);

		for (String attributeName : getTrainingInstances().getHeader().keySet()) {
			if (!attributeName.equals(Instances.CLASS_NAME)) {
				// If attribute == Random
				if (getTrainingInstances().getHeader().get(attributeName) == i) {
					Map<Integer, AttributeValue> attributeValues = getTrainingInstances()
							.getIndexer()
							.getAttributeInstanceIndexesByName(attributeName)
							.getAttributeValues();

					BigDecimal attributeEntropyValue = getTrainingInstances()
							.calculateEntropy(attributeValues);

					// No need to follow ID3.
					minInitialAttributeEntropy = attributeEntropyValue;
					bestInitialAttribute = new Attribute(attributeName,
							attributeValues, attributeEntropyValue);
				}
			}
		}

		bestInitialAttribute.setInformationGain(getHeaderEntropyValue()
				.subtract(minInitialAttributeEntropy,
						Instances.globalMathContext));
		Node rootNode = new Node(null, bestInitialAttribute,
				getTrainingInstances().getIndexer()
				.getAttributeInstanceIndexesByName(
						bestInitialAttribute.getAttributeName()));

		setRootNode(rootNode);
		List<String> processedAttributes = new ArrayList<String>();
		processedAttributes.add(Instances.CLASS_NAME);
		processedAttributes.add(bestInitialAttribute.getAttributeName());
		rootNode.setProcessedAttributes(processedAttributes);
		totalNonLeafNodes ++;
		
		for (AttributeValue attributeValue : bestInitialAttribute
				.getAttributeValues().values()) {
			if (attributeValue.getEntropy().compareTo(new BigDecimal(0)) != 0) {
				rootNode.getCandidatesNodesList().add(attributeValue);
			}
			attributeValue.setCurrentNode(getRootNode());
		}
	}

	public void recursivelyGenerateDecisionTree(Node parent) throws MLException {

		for (Iterator<AttributeValue> candidateAttributeValueIterator = parent
				.getCandidatesNodesList().iterator(); candidateAttributeValueIterator
				.hasNext();) {
			AttributeValue candidateAttributeValue = candidateAttributeValueIterator
					.next();

			BigDecimal minAttributeEntropy = null;
			Attribute bestAttribute = null;
			InstanceIndexer bestInstanceIndexer = null;

			for (String attributeName : getTrainingInstances().getHeader()
					.keySet()) {
				if (!parent.getProcessedAttributes().contains(attributeName)) {

					InstanceIndexer localInstanceIndexer = parent
							.getIndexer()
							.andThenChainAttributeInstanceIndexes(
									candidateAttributeValue.getAttributeName(),
									candidateAttributeValue.getAttributeValue())
									.andThenChainAttributeInstanceIndexes(attributeName);

					Map<Integer, AttributeValue> attributeValues = localInstanceIndexer
							.getAttributeValues();

					BigDecimal attributeEntropyValue = getTrainingInstances()
							.calculateEntropy(attributeValues);

					if (minAttributeEntropy == null
							|| minAttributeEntropy
							.compareTo(attributeEntropyValue) > 0) {
						minAttributeEntropy = attributeEntropyValue;
						bestAttribute = new Attribute(attributeName,
								attributeValues, attributeEntropyValue);
						bestInstanceIndexer = localInstanceIndexer;
					}
				}
			}

			if (bestAttribute != null) {
				bestAttribute.setInformationGain(parent
						.getAttribute()
						.getInformationGain()
						.subtract(minAttributeEntropy,
								Instances.globalMathContext));

				Node currentNode = new Node(parent, bestAttribute,
						bestInstanceIndexer);
				parent.addChild(currentNode);
				currentNode.setEdgeAttributeValue(candidateAttributeValue);

				candidateAttributeValueIterator.remove();
				currentNode.getProcessedAttributes().addAll(
						parent.getProcessedAttributes());
				currentNode.getProcessedAttributes().add(
						bestAttribute.getAttributeName());

				totalNonLeafNodes ++;
				
				for (AttributeValue attributeValue : bestAttribute
						.getAttributeValues().values()) {
					if (attributeValue.getEntropy()
							.compareTo(new BigDecimal(0)) != 0
							&& currentNode.getProcessedAttributes().size() < getTrainingInstances()
							.getHeader().size()) {
						currentNode.getCandidatesNodesList()
						.add(attributeValue);
						recursivelyGenerateDecisionTree(currentNode);
					} else {
						totalDepthSize += parent.getProcessedAttributes().size();
						
						DecisionNode decisionNode = new DecisionNode(
								currentNode);

						int maxCount = 0;
						int maxCountValue = 0;
						for (Map.Entry<Integer, Integer> classifiedCountMapEntry : attributeValue
								.getClassifiedCountMap().entrySet()) {
							int value = classifiedCountMapEntry.getKey();
							int count = classifiedCountMapEntry.getValue();

							if (maxCount == -1 || maxCount < count) {
								maxCount = count;
								maxCountValue = value;
							}
						}
						decisionNode.setDecision(maxCountValue);
						currentNode.setDecisionNode(decisionNode);
						decisionNodesCount ++;
					}
					attributeValue.setCurrentNode(currentNode);
				}
			}
		}
	}

	public void recursivelyGenerateDecisionTreeRandom(Node parent)
			throws MLException {

		for (Iterator<AttributeValue> candidateAttributeValueIterator = parent
				.getCandidatesNodesList().iterator(); candidateAttributeValueIterator
				.hasNext();) {
			AttributeValue candidateAttributeValue = candidateAttributeValueIterator
					.next();

			BigDecimal minAttributeEntropy = null;
			Attribute bestAttribute = null;
			InstanceIndexer bestInstanceIndexer = null;

			Random gen = new Random();
			int i = gen.nextInt(getTrainingInstances().getHeader().size());

			for (String attributeName : getTrainingInstances().getHeader()
					.keySet()) {

				// If attribute == Random
				if (getTrainingInstances().getHeader().get(attributeName) == i) {

					if (!parent.getProcessedAttributes()
							.contains(attributeName)) {

						InstanceIndexer localInstanceIndexer = parent
								.getIndexer()
								.andThenChainAttributeInstanceIndexes(
										candidateAttributeValue
										.getAttributeName(),
										candidateAttributeValue
										.getAttributeValue())
										.andThenChainAttributeInstanceIndexes(
												attributeName);

						Map<Integer, AttributeValue> attributeValues = localInstanceIndexer
								.getAttributeValues();

						BigDecimal attributeEntropyValue = getTrainingInstances()
								.calculateEntropy(attributeValues);

						minAttributeEntropy = attributeEntropyValue;
						bestAttribute = new Attribute(attributeName,
								attributeValues, attributeEntropyValue);
						bestInstanceIndexer = localInstanceIndexer;

						break;
					}
				}
			}

			if (bestAttribute != null) {
				
				bestAttribute.setInformationGain(parent
						.getAttribute()
						.getInformationGain()
						.subtract(minAttributeEntropy,
								Instances.globalMathContext));

				Node currentNode = new Node(parent, bestAttribute,
						bestInstanceIndexer);
				parent.addChild(currentNode);
				currentNode.setEdgeAttributeValue(candidateAttributeValue);

				candidateAttributeValueIterator.remove();
				currentNode.getProcessedAttributes().addAll(
						parent.getProcessedAttributes());
				currentNode.getProcessedAttributes().add(
						bestAttribute.getAttributeName());

				for (AttributeValue attributeValue : bestAttribute
						.getAttributeValues().values()) {
					if (attributeValue.getEntropy()
							.compareTo(new BigDecimal(0)) != 0
							&& currentNode.getProcessedAttributes().size() < getTrainingInstances()
							.getHeader().size()) {
						totalNonLeafNodes ++;
						
						currentNode.getCandidatesNodesList()
						.add(attributeValue);
						recursivelyGenerateDecisionTree(currentNode);
					} else {
						totalDepthSize += parent.getProcessedAttributes().size();
						
						DecisionNode decisionNode = new DecisionNode(
								currentNode);

						int maxCount = 0;
						int maxCountValue = 0;
						for (Map.Entry<Integer, Integer> classifiedCountMapEntry : attributeValue
								.getClassifiedCountMap().entrySet()) {
							int value = classifiedCountMapEntry.getKey();
							int count = classifiedCountMapEntry.getValue();

							if (maxCount == -1 || maxCount < count) {
								maxCount = count;
								maxCountValue = value;
							}
						}
						decisionNode.setDecision(maxCountValue);
						currentNode.setDecisionNode(decisionNode);
						decisionNodesCount ++;
					}
					attributeValue.setCurrentNode(currentNode);
				}
			}
		}
	}

	public void generateDecisionTreeRandom() throws MLException {
		try {
			generateInitialDecisionTreeRandom();

			recursivelyGenerateDecisionTreeRandom(getRootNode());
		} catch (MLException exception) {
			throw new MLException(
					" exception while generating decision tree with random selection !",
					exception);
		}
	}

	public void generateDecisionTree() throws MLException {
		try {
			generateInitialDecisionTree();

			recursivelyGenerateDecisionTree(getRootNode());
		} catch (MLException exception) {
			throw new MLException(
					" exception while generating decision tree !", exception);
		}
	}

	public void printDecisionTree() {
		StringBuffer treePrintingStringBuffer = new StringBuffer();
		recursivePrintDecisionTree(treePrintingStringBuffer, 0, getRootNode());

		System.out.println(treePrintingStringBuffer.toString());
	}

	public void recursivePrintDecisionTree(StringBuffer levelStatement,
			int level, Node node) {
		levelStatement.append("\n");
		StringBuffer seperator = new StringBuffer();

		for (int index = 0; index < level; index++)
			seperator.append(" | ");

		levelStatement.append(seperator.toString()).append(
				node.getAttribute().getAttributeName());

		Map<Integer, AttributeValue> nodeAttributeValuesMap = node
				.getAttribute().getAttributeValues();

		boolean reFillMarking = false;
		for (AttributeValue attributeValue : nodeAttributeValuesMap.values()) {
			Node matchingChildNode = null;

			for (Iterator<Node> nodesIterator = node.getChildren().iterator(); nodesIterator
					.hasNext();) {
				Node childnode = nodesIterator.next();
				if (childnode.getEdgeAttributeValue().getAttributeValue() == attributeValue
						.getAttributeValue())
					matchingChildNode = childnode;
			}

			if (reFillMarking)
				levelStatement.append("\n" + seperator.toString()).append(
						node.getAttribute().getAttributeName());

			levelStatement.append(" = " + attributeValue.getAttributeValue()
					+ " : ");

			if (matchingChildNode == null) {
				if (node.getDecisionNode() == null) {
					System.out.println(" ok ");
				}
				levelStatement.append(node.getDecisionNode().getDecision());
				reFillMarking = true;
			} else {
				recursivePrintDecisionTree(levelStatement, level + 1,
						matchingChildNode);
				reFillMarking = true;
			}
		}
	}

	public boolean validateInstance(Instance instance) {
		AttributeDO[] attributeDOs = instance.getAttributeDOs();
		Integer attributeIndex = getTrainingInstances().getHeader().get(
				Instances.CLASS_NAME);

		if (validate(getRootNode(), attributeDOs) == attributeDOs[attributeIndex]
				.getValue())
			return true;
		else
			return false;
	}

	public Integer validate(Node node, AttributeDO[] attributeDOs) {
		String currentAttributeName = node.getAttribute().getAttributeName();
		Integer attributeIndex = getTrainingInstances().getHeader().get(
				currentAttributeName);

		AttributeDO attributeDO = attributeDOs[attributeIndex];
		Integer attributeValue = attributeDO.getValue();

		Node nextLevelNode = null;
		for (Node childNode : node.getChildren()) {
			if (childNode.getEdgeAttributeValue().getAttributeValue()
					.equals(attributeValue))
				nextLevelNode = childNode;
		}

		if (nextLevelNode == null) {
			return node.getDecisionNode().getDecision();
		}

		return validate(nextLevelNode, attributeDOs);
	}

	public BigDecimal validateInstances(Instances instances) {
		int trueCount = 0;

		for (Instance instance : instances.getInstances())
			trueCount += (validateInstance(instance) ? 1 : 0);

		return new BigDecimal(trueCount).divide(
				new BigDecimal(instances.getInstances().length),
				Instances.globalMathContext).multiply(new BigDecimal(100),
						Instances.globalMathContext);
	}

	public static void removeRandomNode(Node node) {
		Random random = new Random();
		Node replacingNode = null;
		Node traversingNode = node;
		int depth = 1;
		boolean isDetected = false;

		while (traversingNode.getChildren().size() > 0) {
			int randomAttributeIndex = random.nextInt(traversingNode
					.getChildren().size());

			if (traversingNode.getChildren().size() == 0) {
				break;
			} else {
				traversingNode = traversingNode.getChildren().get(
						randomAttributeIndex);
			}

			if (depth == (random.nextInt(10) + 3) && !isDetected) {
				replacingNode = traversingNode;
				isDetected = true;
			}

			depth++;
		}

		DecisionNode decisionNode = traversingNode.getDecisionNode();

		if (replacingNode == null || replacingNode == node
				|| replacingNode.getParent() == null)
			return;

		Node replacingNodeParent = replacingNode.getParent();
		replacingNodeParent.getChildren().clear();
		replacingNodeParent.setDecisionNode(decisionNode);
	}

	public static DecisionTreeAlgorithm pruneDecisionTree(int lvalue,
			int kvalue, String trainingSetLocation, String validationSetLocation) {
		DecisionTreeAlgorithm bestDta = null;

		try {
			DecisionTreeAlgorithm dta = new DecisionTreeAlgorithm();
			dta.train(trainingSetLocation);
			dta.generateDecisionTree();

			List<String> validationDataLines = Utility
					.loadFile(validationSetLocation);
			Instances validationInstances = Utility
					.loadInstancesFromData(validationDataLines);

			BigDecimal originalAccuracy = dta
					.validateInstances(validationInstances);

			for (int lvalueIndex = 0; lvalueIndex < lvalue; lvalueIndex++) {
				int mvalue = new Random().nextInt(kvalue) + 1;

				dta = new DecisionTreeAlgorithm();
				dta.train(trainingSetLocation);
				dta.generateDecisionTree();

				for (int mvalueIndex = 0; mvalueIndex < mvalue; mvalueIndex++)
					removeRandomNode(dta.getRootNode());

				BigDecimal runAccuracy = dta
						.validateInstances(validationInstances);
				if (originalAccuracy.compareTo(runAccuracy) < 0) {
					bestDta = dta;
					originalAccuracy = runAccuracy;
				} else {
					System.out
					.println(" Decision Tree accuracy after prunning is : "
							+ runAccuracy);
				}
			}
		} catch (MLException e) {
			e.printStackTrace();
		}

		return bestDta;
	}

	public static void main(String[] args) {
		if (args == null || args.length < 7) {
			System.out.println(" Insufficient number of parameters : ");
			System.out.println(" Please provide params : ");
			System.out.println(" a) L");
			System.out.println(" b) K");
			System.out.println(" c) <training-set>");
			System.out.println(" d) <validation-set>");
			System.out.println(" e) <test-set>");
			System.out.println(" f) <to-print>");
			System.out.println(" g) <is-random>");

			System.exit(1);
		}

		try {
			int lvalue = Integer.valueOf(args[0]);
			int kvalue = Integer.valueOf(args[1]);

			String trainingSetLocation = args[2];
			String validationSetLocation = args[3];
			String testSetLocation = args[4];
			Boolean toPrint = Boolean
					.valueOf((args[5].equalsIgnoreCase("yes") ? true : false));

			DecisionTreeAlgorithm dta = new DecisionTreeAlgorithm();

			Boolean toRandom = Boolean
					.valueOf((args[6].equalsIgnoreCase("yes") ? true : false));

			dta.train(trainingSetLocation);

			if (toRandom) {
				dta.generateDecisionTreeRandom();
			} else {
				dta.generateDecisionTree();
			}

			if (toPrint) {
				System.out.println(" Decision Tree : ");
				dta.printDecisionTree();

			}

			List<String> validationDataLines = Utility
					.loadFile(validationSetLocation);
			Instances validationInstances = Utility
					.loadInstancesFromData(validationDataLines);

			System.out.println(" Validation data accuracy : "
					+ dta.validateInstances(validationInstances));

			List<String> testDataLines = Utility.loadFile(testSetLocation);
			Instances testInstances = Utility
					.loadInstancesFromData(testDataLines);

			System.out.println(" Test data accuracy : "
					+ dta.validateInstances(testInstances));
			if(kvalue != 0 ) {
				DecisionTreeAlgorithm bestDta = pruneDecisionTree(lvalue, kvalue,
						trainingSetLocation, testSetLocation);
				if (bestDta == null) {
					System.out
					.println("Pruning didnt increased efficiency, please try changing value of K .");
				} else {
					System.out.println(" Best Decision Tree accuracy  : "
							+ bestDta.validateInstances(validationInstances));
					if (toPrint) {
						System.out.println(" Best Decision Tree post pruning :");
						bestDta.printDecisionTree();
					}
				}
			}
			
			System.out.println(" Average Depth : " + (dta.getTotalDepthSize()/dta.getDecisionNodesCount()));
			System.out.println(" Number of nodes  : " + (dta.getTotalNonLeafNodes()));
						
		} catch (MLException e) {
			e.printStackTrace();
			System.exit(1);
		}
	}

}