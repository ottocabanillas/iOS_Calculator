//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Oscar Cabanillas on 06/04/2022.
//

import UIKit

final class HomeViewController: UIViewController {

  // MARK: - Outlets

  // Result
  @IBOutlet weak var resultLabel: UILabel!

  // Number
  @IBOutlet weak var number0: UIButton!
  @IBOutlet weak var number1: UIButton!
  @IBOutlet weak var number2: UIButton!
  @IBOutlet weak var number3: UIButton!
  @IBOutlet weak var number4: UIButton!
  @IBOutlet weak var number5: UIButton!
  @IBOutlet weak var number6: UIButton!
  @IBOutlet weak var number7: UIButton!
  @IBOutlet weak var number8: UIButton!
  @IBOutlet weak var number9: UIButton!
  @IBOutlet weak var numberDecimal: UIButton!

  // Operators
  @IBOutlet weak var operatorAC: UIButton!
  @IBOutlet weak var operatorPlusMinus: UIButton!
  @IBOutlet weak var operatorPercent: UIButton!

  @IBOutlet weak var operatorResult: UIButton!
  @IBOutlet weak var operatorAddition: UIButton!
  @IBOutlet weak var operatorSubstract: UIButton!
  @IBOutlet weak var operatorMultiplication: UIButton!
  @IBOutlet weak var operatorDivision: UIButton!

  // MARK: - Variables
  private var total: Double = 0                 // Total
  private var temp: Double = 0                  // Valor por pantalla
  private var operating: Bool = false           // Indicar si se ha seleccionado un operador
  private var decimal: Bool = false             // Indicar si el valor es decimal
  private var operation: OperationType = .none  // Operacion actual

  // MARK: - Constants
  private enum OperationType {
    case none
    case addiction
    case substraction
    case multiplication
    case division
    case percent
  }

  private let kDecimalSeparator = Locale.current.decimalSeparator!
  private let kMaxLength: Int = 9
  private let kTotal = "total"

  // Formateo de valores auxiliar
  private let auxFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    let locale = Locale.current
    formatter.groupingSeparator = ""
    formatter.currencyDecimalSeparator = locale.decimalSeparator
    formatter.numberStyle = .decimal
    formatter.maximumIntegerDigits = 100
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 100
    return formatter
  }()

  // Formateo de valores auxiliar 2
  private let auxTotalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    let locale = Locale.current
    formatter.groupingSeparator = ""
    formatter.currencyDecimalSeparator = ""
    formatter.numberStyle = .decimal
    formatter.maximumIntegerDigits = 100
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 100
    return formatter
  }()

  // Formateo de valores por pantalla por defecto
  private let printFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    let locale = Locale.current
    formatter.groupingSeparator = locale.groupingSeparator
    formatter.decimalSeparator = locale.decimalSeparator
    formatter.numberStyle = .decimal
    formatter.maximumIntegerDigits = 9
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 8
    return formatter
  }()

  // Formateo de valores por pantalla en formato cientifico
  private let printScientificFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .scientific
    formatter.maximumFractionDigits = 3
    formatter.exponentSymbol = "e"
    return formatter
  }()

  // MARK: - Initialization

  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()


    numberDecimal.setTitle(kDecimalSeparator, for: .normal)
    total = UserDefaults.standard.double(forKey: kTotal)
    result()

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupView()
  }

  // MARK: - Button Actions

  // Operators
  @IBAction func operatorACAction(_ sender: UIButton) {
    clear()
    sender.shine()
  }

  @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
    temp = temp * (-1)
    resultLabel.text = printFormatter.string(from: NSNumber(value: temp))
    sender.shine()
  }

  @IBAction func operatorPercentAction(_ sender: UIButton) {
    if operation != .percent {
      result()
    }
    operating = true
    operation = .percent
    result()
    sender.shine()
  }

  @IBAction func operatorResultAction(_ sender: UIButton) {
    result()
    sender.shine()
  }

  @IBAction func operatorAdditionAction(_ sender: UIButton) {

    if operation != .none {
      result()
    }

    operating = true
    operation = .addiction
    sender.selectOperation(true)

    sender.shine()
  }

  @IBAction func operatorSubstractAction(_ sender: UIButton) {
    if operation != .none {
      result()
    }

    operating = true
    operation = .substraction
    sender.selectOperation(true)
    sender.shine()
  }

  @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
    if operation != .none {
      result()
    }

    operating = true
    operation = .multiplication
    sender.selectOperation(true)
    sender.shine()
  }

  @IBAction func operatorDivisionAction(_ sender: UIButton) {
    if operation != .none {
      result()
    }

    operating = true
    operation = .division
    sender.selectOperation(true)
    sender.shine()
  }

  // Numbers
  @IBAction func numberDecimalAction(_ sender: UIButton) {

    let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
    if !operating && currentTemp.count >= kMaxLength {
      return
    }

    resultLabel.text = resultLabel.text! + kDecimalSeparator
    decimal = true

    selectVisualOperation()

    sender.shine()
  }

  @IBAction func numberAction(_ sender: UIButton) {

    print(sender.tag)
    operatorAC.setTitle("C", for: .normal)
    var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
    if !operating && currentTemp.count >= kMaxLength {
      return
    }

    currentTemp = auxFormatter.string(from: NSNumber(value: temp))!

    // Hemos seleccionado una operación
    if operating {
      total = total == 0 ? temp : total
      resultLabel .text = ""
      currentTemp = ""
      operating = false
    }

    // Hemos seleccionado decimales
    if decimal {
      currentTemp = "\(currentTemp)\(kDecimalSeparator)"
      decimal = false
    }

    let number = sender.tag
    temp = Double(currentTemp + String(number))!
    resultLabel.text = printFormatter.string(from: NSNumber(value: temp))

    selectVisualOperation()

    sender.shine()
//    print(sender.tag)
  }

  private func setupView() {
    // UI
    number0.round()
    number1.round()
    number2.round()
    number3.round()
    number4.round()
    number5.round()
    number6.round()
    number7.round()
    number8.round()
    number9.round()
    numberDecimal.round()

    operatorAC.round()
    operatorPlusMinus.round()
    operatorPercent.round()
    operatorResult.round()
    operatorAddition.round()
    operatorSubstract.round()
    operatorMultiplication.round()
    operatorDivision.round()
  }

  // Limpia los valores
  private func clear() {
    operation = .none
    operatorAC.setTitle("AC", for: .normal)
    if temp != 0 {
      temp = 0
      resultLabel.text = "0"
    } else {
       total = 0
       result()
    }
  }

  // Obtiene el resultado final
  private func result() {

    switch operation {

    case .none:
      // No hacemos nada
      break
    case .addiction:
      total = total + temp
      break
    case .substraction:
      total = total - temp
      break
    case .multiplication:
      total = total * temp
      break
    case .division:
      total = total / temp
      break
    case .percent:
      temp = temp / 100
      total = temp
      break
    }
    // Formateo en pantalla

    if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength{
      resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
    } else {
      resultLabel.text = printFormatter.string(from: NSNumber(value: total))
    }

//    if total <= kMaxValue ||  total >= kMinValue {
//      resultLabel.text = printFormatter.string(from: NSNumber(value: total))
//    }

    operation = .none

    selectVisualOperation()

    UserDefaults.standard.set(total, forKey: kTotal)

    print("TOTAL \(total)")

  }

  // Muestra de forma visual la operacion seleccionada
  private func selectVisualOperation() {
    if !operating {
      // No estamos operando
      operatorAddition.selectOperation(false)
      operatorSubstract.selectOperation(false)
      operatorMultiplication.selectOperation(false)
      operatorDivision.selectOperation(false)
    } else {
      switch operation {
      case .none, .percent:
        operatorAddition.selectOperation(false)
        operatorSubstract.selectOperation(false)
        operatorMultiplication.selectOperation(false)
        operatorDivision.selectOperation(false)
        break
      case .addiction:
        operatorAddition.selectOperation(true)
        operatorSubstract.selectOperation(false)
        operatorMultiplication.selectOperation(false)
        operatorDivision.selectOperation(false)
        break
      case .substraction:
        operatorAddition.selectOperation(false)
        operatorSubstract.selectOperation(true)
        operatorMultiplication.selectOperation(false)
        operatorDivision.selectOperation(false)
        break
      case .multiplication:
        operatorAddition.selectOperation(false)
        operatorSubstract.selectOperation(false)
        operatorMultiplication.selectOperation(true)
        operatorDivision.selectOperation(false)
        break
      case .division:
        operatorAddition.selectOperation(false)
        operatorSubstract.selectOperation(false)
        operatorMultiplication.selectOperation(false)
        operatorDivision.selectOperation(true)
        break
      }
    }
  }

}
